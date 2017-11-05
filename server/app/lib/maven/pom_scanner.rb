require_relative '../common/vulnerability'
require_relative '../common/scanner'
require_relative '../msg_constants'
require_relative 'pom_version_logic'

class PomScanner < Scanner

  def initialize(deps)
    super(deps)
  end


  def scan_all_deps
    vuln_hash = {}
    @deps.each do |dep|
      dep_name = dep['groupId']+'.'+dep['artifactId']
      vuln_hash[dep_name] = []
      JavaCve.all.each do |cve|
        for affected in cve['affected']
          if affected['groupId'] == dep['groupId'] and affected['artifactId'] == dep['artifactId']
            print 'CVE with same group/artifact id, check versions'
             if PomVersionLogic::is_vuln?(dep['version'],affected['version'],affected['fixedin'])
               vuln_hash[dep_name].push( Vulnerability::new(dep['version'],affected['fixedin'],cve.cve_id))
             end
          end
        end
      end
    end
    vuln_hash
  end

end
