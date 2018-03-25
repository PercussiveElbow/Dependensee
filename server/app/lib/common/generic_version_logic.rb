class GenericVersionLogic

  # OTHER
  def self.vuln_cleanup(vuln_list)
    vuln_list.delete_if { |_, v| v['cves'].empty? }
  end

  def self.overall_version(vuln_list)
    vuln_list.each do |_,vh|
      overall_patch = '0.0.0'
      vh['cves'].each do |cve|
          overall_patch = GenericVersionLogic::handle_patched_ver_loop(cve,overall_patch)
      end
      vh['overall_patch'] = overall_patch
    end
    vuln_list
  end

  def self.handle_patched_ver_loop(cve,overall_patch)
    unless cve.patched_version.nil?
      cve.patched_version.each do |patch_ver|
        overall_patch = GenericVersionLogic::overall_ver_replace(patch_ver, overall_patch)
      end
    end
    overall_patch
  end

  def self.overall_ver_replace(patch_ver,overall_patch)
    if !patch_ver.include? ','
        overall_patch = check_replace(patch_ver,overall_patch)
    else
      patch_ver_split = patch_ver.split(',')
      for a_ver in patch_ver_split
        overall_patch = self.overall_ver_replace(a_ver, overall_patch)
      end
    end
    overall_patch
  end

  def self.check_replace(patch_ver,overall_patch)
    ver = Gem::Version.new(patch_ver.gsub('>', '').gsub(' ','').gsub('=','').gsub('~',''))
    if ver >= Gem::Version.new(overall_patch.gsub('>', '').gsub(' ', '').gsub('=', '').gsub('~', ''))
      overall_patch = patch_ver
    end
    overall_patch
  end

  def self.finish_version_logic(vuln_list)
    GenericVersionLogic::overall_version(GenericVersionLogic::vuln_cleanup(vuln_list))
  end

end