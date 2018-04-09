require 'rss'
require 'open-uri'

class GemVersionLogic

  def self.is_above_patched_ver(gem_ver, patch_ver)
    case patch_ver
      when />=/
        return Gem::Version.new(gem_ver) >= Gem::Version.new(patch_ver.gsub('>=', '').gsub(' ',''))
      when /~>/
        return Gem::Dependency.new('', patch_ver).match?('', gem_ver)
      else
        return false
    end
  end

  def self.unaffected?(gem_ver, safe_ver)
    if safe_ver.include? ','
      safe_ver_split = safe_ver.split(',')
      for ver in safe_ver_split
        return true if GemVersionLogic::unaffected?(gem_ver,ver)
      end
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

  def self.is_within_minor_ver(gem_ver,patch_ver)
    return patch_ver.to_s.tr('>=<~ ', '')[0,3] == gem_ver.to_s.tr('>=<~ ', '')[0,3]
  end

  def self.query_rubygems(gem_name)
    RSS::Parser.parse("https://rubygems.org/gems/#{gem_name}/versions.atom",false).items[0].title.content.gsub(gem_name,'').tr('()', '')
  end

  def self.get_latest_version(gem_name)
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

