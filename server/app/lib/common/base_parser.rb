
class BaseParser
  # Base class for extending on Parser logic

  def initialize
    @dependencies=nil
    @sources=nil
  end

  def load_dependencies
    @dependencies
  end

  def load_sources
    @sources
  end

end