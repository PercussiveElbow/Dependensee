require_relative '../common/vulnerability'
require_relative '../common/scanner'
require_relative '../msg_constants'
require_relative 'pom_version_logic'

class PipScanner < Scanner

  def initialize(deps)
    super(deps)
  end

  def scan
    $maven_pip_db.update?
    vuln_hash = {}

      #TODO IMPLEMENT
    vuln_hash
  end

end
