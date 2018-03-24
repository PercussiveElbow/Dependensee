require 'rss'
require 'open-uri'

class GemVersionLogic
  # Constant that I should really change
  TIMEOUT = 14400

  def self.is_vuln?(dep_ver,vuln_ver,unaffected)
    vuln = false
    vuln_ver.each { |ver|
      if GemVersionLogic::affected?(ver, dep_ver.gsub(/[^0-9.]/, ''))
        vuln=true; break;
      end
    }
    if !fixed_in.nil?
      fixed_in.each { |fixed_ver|
        if GemVersionLogic::unaffected?(fixed_ver,dep_ver.gsub(/[^0-9.]/, ''))
          vuln=false; break;
        end
      }
    end
    return vuln
  end

  def self.is_above_patched_ver(gem_ver, patch_ver)
    if patch_ver.include? '>='
      return Gem::Version.new(gem_ver) >= Gem::Version.new(patch_ver.gsub('>=', '').gsub(' ',''))
    elsif patch_ver.include? '~>'
      return Gem::Dependency.new('', patch_ver).match?('', gem_ver)
    else #todo check how semantics work here
      return false
    end
  end


  def self.unaffected?(gem_ver, safe_ver) #replace with switch, add pess case too
    if safe_ver.include? ',' #case for a between
      safe_ver_split = safe_ver.split(',')
      for ver in safe_ver_split
        if GemVersionLogic::unaffected?(gem_ver,ver)
          return true
        end
      end
      return false
    end
    if safe_ver.include? '<' ##There's no nice way to do >=, should really
      if safe_ver.include? '<='; return (Gem::Version.new(gem_ver) < Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(gem_ver) == Gem::Version.new(safe_ver.gsub(/[^0-9.]/, '')))
      else return Gem::Version.new(gem_ver) < Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))
      end
    elsif safe_ver.include? '>'
      if safe_ver.include? '>='; return (Gem::Version.new(gem_ver) > Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(gem_ver) == Gem::Version.new(safe_ver.gsub(/[^0-9.]/, '')))
      else; return is_within_minor_ver(gem_ver,safe_ver) && Gem::Version.new(gem_ver) > Gem::Version.new(safe_ver.gsub(/[^0-9.]/, ''))
      end
    end
  end

  def self.is_within_minor_ver(gem_ver,patch_ver)
    return patch_ver.to_s.tr('>=<~ ', '')[0,3] == gem_ver.to_s.tr('>=<~ ', '')[0,3]
  end

  def self.query_rubygems(gem_name)
      open("https://rubygems.org/gems/#{gem_name}/versions.atom") do |rss|
        return RSS::Parser.parse(rss,false).items[0].title.content.gsub(gem_name,'').tr('()', '')
      end
  end

  def self.get_latest_version(gem_name)
    begin
      $h = Hash.new if $h.nil?
      if  $h[gem_name].nil? or ((Time.now.to_i - $h[gem_name][1].to_i)> MsgConstants::TIMEOUT)
        $h[gem_name] = [query_rubygems(gem_name), Time.now.to_i]
      end
      return $p[gem_name][0]
    rescue
      return MsgConstants::LATEST_VER_ERROR
    end
  end

end

