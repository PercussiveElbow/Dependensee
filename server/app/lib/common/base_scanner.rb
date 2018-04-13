require_relative '../msg_constants'
require_relative 'generic_version_logic'
require_relative 'vulnerability'

class BaseScanner
  # Base Scanner class for extending

  def initialize(deps)
    @deps=deps
  end

end