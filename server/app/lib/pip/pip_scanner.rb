require_relative '../common/vulnerability'
require_relative '../common/scanner'
require_relative '../msg_constants'
require_relative 'pip_version_logic'

class PipScanner < Scanner

  def initialize(deps)
    super(deps)
  end

  def scan
    $maven_pip_db.update?
    vuln_hash = {}
    @deps.each do |dep|
      vuln_hash[dep['name']] = []
      PythonCve.all.each do |cve|
        cve
        for affected in cve['affected']
          if affected['name'] == dep['name'] and PipVersionLogic::is_vuln?(dep['version'],affected['version'],affected['fixedin'])
            vuln_hash[dep['name']].push( Vulnerability::new(dep['version'],affected['fixedin'],cve.cve_id))
          end
        end
      end
    end
    vuln_hash
  end

end
