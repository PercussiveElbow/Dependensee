class GenericVersionLogic

  # OTHER
  def self.vuln_cleanup(vuln_list)
    vuln_list.delete_if { |_, v| v['cves'].empty? }
  end

  def self.overall_version(vuln_list)
    vuln_list.each do |_,vh|
      overall_patch = '0.0.0'
      our_ver = vh['cves'][0] if !vh['cves'].empty?
      vh['cves'].each do |cve|

        if !cve.patched_version.nil?
          cve.patched_version.each do |patch_ver|
            if !patch_ver.include? ',' #todo fix
              ver = Gem::Version.new(patch_ver.gsub('>', '').gsub(' ','').gsub('=','').gsub('~',''))
              if ver >= Gem::Version.new(overall_patch.gsub('>', '').gsub(' ', '').gsub('=', '').gsub('~', ''))
                overall_patch = patch_ver
              end
            end
          end
        end
      end
      vh['overall_patch'] = overall_patch
    end
    vuln_list
  end

  def self.finish_version_logic(deps,vuln_list)
    vuln_list = GenericVersionLogic::vuln_cleanup(vuln_list)
    vuln_list = GenericVersionLogic::overall_version(vuln_list)

    deps.each { |dep|
      if vuln_list.key?(dep.name)
        dep['update_to'] = vuln_list[dep.name]['overall_patch']
        dep.save
      end
    }
    vuln_list
  end
end