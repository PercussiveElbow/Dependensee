require_relative '../common/vulnerability'
require_relative '../common/base_scanner'
require_relative '../msg_constants'
require_relative 'pom_version_logic'

class PomScanner < BaseScanner

  def initialize(deps)
    super(deps)
  end

  def scan
    $maven_pip_db.update?
    vuln_hash = {}
    @deps.each do |dep|
      dep_name = dep.name
      vuln_hash[dep.name] = {}
      vuln_hash[dep.name]['cves'] = []
      dep_group_id = dep.name.rpartition('.')[0]
      dep_artifact_id = dep.name.rpartition('.')[2]
      JavaCve.all.each do |cve|
        cve['affected'].each { |affected|
          if affected['groupId'] == dep_group_id and affected['artifactId'] == dep_artifact_id and  PomVersionLogic::is_vuln?(dep.version, affected['version'], affected['fixedin'])
            vuln_hash[dep_name]['cves'].push(Vulnerability::new(dep.version, affected['fixedin'], cve.cve_id))
          end
        }
      end
    end
    vuln_hash
  end


end
