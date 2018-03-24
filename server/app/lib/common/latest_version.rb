
class LatestVersion

  def self.get_latest(language, dep_name)
    case language
      when 'Ruby'
        GemVersionLogic::get_latest_version(dep_name)
      when 'Java'
        PomVersionLogic::get_latest_version(dep_name)
      when 'Python'
        PipVersionLogic::get_latest_version(dep_name)
    end
  end

end