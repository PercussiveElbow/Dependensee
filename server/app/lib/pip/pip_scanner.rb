require_relative '../common/base_scanner'
require_relative 'pip_version_logic'

class PipScanner < BaseScanner

  def initialize(deps)
    super(deps)
  end

  def scan # Scan pip dependencies for any vulnerabilities
    $maven_pip_db.update?
    vuln_hash = {}
    @deps.each do |dep|
      vuln_hash[dep.name] = {}
      vuln_hash[dep.name]['cves'] = []
      PythonCve.all.each do |cve|
        cve['affected'].each { |affected|
          if affected['name'] == dep.name and PipVersionLogic::is_vuln?(dep.version, affected['version'], affected['fixedin'])
            vuln_hash[dep.name]['cves'].push(Vulnerability::new(dep.version, affected['fixedin'], cve.cve_id))
          end
        }
      end
    end
    GenericVersionLogic::finish_version_logic(vuln_hash)
  end

end
