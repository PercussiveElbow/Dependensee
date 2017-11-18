require_relative '../common/vulnerability'
require_relative '../common/scanner'
require_relative '../msg_constants'
require_relative 'pom_version_logic'

class PomScanner < Scanner

  def initialize(deps)
    super(deps)
  end

  def scan
    $maven_pip_db.update?
    vuln_hash = {}
    @deps.each do |dep|
      dep_name = dep.name
      dep_group_id = dep.name.rpartition('.')[0]
      dep_artifact_id = dep.name.rpartition('.')[2]
      vuln_hash[dep_name] = []
      JavaCve.all.each do |cve|
        cve['affected'].each { |affected|
          if affected['groupId'] == dep_group_id and affected['artifactId'] == dep_artifact_id and  PomVersionLogic::is_vuln?(dep.version, affected['version'], affected['fixedin'])
            vuln_hash[dep_name].push(Vulnerability::new(dep.version, affected['fixedin'], cve.cve_id))
          end
        }
      end
    end
    vuln_hash
  end


end
