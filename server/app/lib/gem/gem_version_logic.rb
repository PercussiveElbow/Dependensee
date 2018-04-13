require 'rss'

class GemVersionLogic

  def self.is_above_patched_ver(gem_ver, patch_ver) # Check if the version is above patched
    case patch_ver
      when />=/
        return Gem::Version.new(gem_ver) >= Gem::Version.new(patch_ver.gsub('>=', '').gsub(' ',''))
      when /~>/
        return Gem::Dependency.new('', patch_ver).match?('', gem_ver)
      else
        return false
    end
  end

  def self.unaffected?(gem_ver, safe_ver) # Check if the version is unaffected
    if safe_ver.include? ','
      safe_ver.split(',').each { |ver|
        return true if GemVersionLogic::unaffected?(gem_ver, ver)
      }
      return false
    end
    GemVersionLogic::unaffected_logic(gem_ver,safe_ver)
  end

  def self.unaffected_logic(gem_ver,safe_ver)
    case safe_ver
      when /<=/
        return (Gem::Version.new(gem_ver) < Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(gem_ver) == Gem::Version.new(safe_ver.gsub(/[^0-9.]/, '')))
      when /</
        return Gem::Version.new(gem_ver) < Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))
      when />=/
        return (Gem::Version.new(gem_ver) > Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(gem_ver) == Gem::Version.new(safe_ver.gsub(/[^0-9.]/, '')))
      when />/
        return is_within_minor_ver(gem_ver,safe_ver) && Gem::Version.new(gem_ver) > Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))
    end
  end

  def self.is_within_minor_ver(gem_ver,patch_ver) # Method to calculate whether a major update will be needed
    return patch_ver.to_s.tr('>=<~ ', '')[0,3] == gem_ver.to_s.tr('>=<~ ', '')[0,3]
  end

  def self.query_rubygems(gem_name) # call rubygems to get latest version of gem
    RSS::Parser.parse("https://rubygems.org/gems/#{gem_name}/versions.atom",false).items[0].title.content.gsub(gem_name,'').tr('()', '')
  end

  def self.get_latest_version(gem_name) # check cache for dependency version, otherwise call rubygems
    begin
      $h = Hash.new if $h.nil?
      if  $h[gem_name].nil? or ((Time.now.to_i - $h[gem_name][1].to_i)> MsgConstants::TIMEOUT)
        $h[gem_name] = [query_rubygems(gem_name), Time.now.to_i]
      end
      return $h[gem_name][0]
    rescue StandardError => e
      return MsgConstants::LATEST_VER_ERROR
    end
  end

end

