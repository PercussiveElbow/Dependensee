require_relative '../common/vulnerability'
require_relative '../common/base_scanner'
require_relative '../msg_constants'
require_relative 'pip_version_logic'

class PipScanner < BaseScanner

  def initialize(deps)
    super(deps)
  end

  def scan
    $maven_pip_db.update?
    vuln_hash = {}
    @deps.each do |dep|
      vuln_hash[dep.name] = []
      PythonCve.all.each do |cve|

        cve['affected'].each { |affected|

          if affected['name'] == 'GeoAlchemy'
            print affected
          end
          if affected['name'] == dep.name and PipVersionLogic::is_vuln?(dep.version, affected['version'], affected['fixedin'])
            vuln_hash[dep.name].push(Vulnerability::new(dep.version, affected['fixedin'], cve.cve_id))
          end
        }
      end
    end
    vuln_hash
  end

end
