require 'rss'
require 'open-uri'

class PipVersionLogic

  def self.is_vuln?(dep_ver,vuln_ver,fixed_in)
    vuln = false
    for ver in vuln_ver do
      if self.is_below_vuln_ver(ver,dep_ver)
        vuln=true; break;
      end
    end
    return vuln
  end

  def self.is_below_vuln_ver(vuln_ver,dep_ver)
    if vuln_ver.include? ',' #case for a between
      print('Analysis failed, fix this') # TODO FIX
      return false
    end
    if vuln_ver.include? '<' ##There's no nice way to do >=, should really
      if vuln_ver.include? '<='; return (Gem::Version.new(dep_ver) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(dep_ver) == Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')))
      else; return Gem::Version.new(dep_ver) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))
      end
    end
  end
  #
  # def self.is_within_minor_ver(gem_ver,patch_ver)
  #   return patch_ver.to_s.tr('>=<~ ', '')[0,3] == gem_ver.to_s.tr('>=<~ ', '')[0,3]
  # end

end

