require 'rss'
require 'open-uri'

class PipVersionLogic

  # noinspection RubyUnusedLocalVariable
  def self.is_vuln?(dep_ver,vuln_ver,fixed_in)
    vuln = false
    vuln_ver.each { |ver|
      if self.is_below_vuln_ver(ver, dep_ver)
        vuln=true; break;
      end
    }
    return vuln
  end

  def self.is_below_vuln_ver(vuln_ver,dep_ver)
    if vuln_ver.include? ',' #case for a between
      print('Analysis failed, fix this') # TODO FIX
      return false
    end
    # Pip includes version constraints, so =>/== but ignore => for now
    dep_ver_tidy = dep_ver.gsub('=','').gsub('>','')

    if vuln_ver.include? '=='
      return Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')) == Gem::Version.new(dep_ver.gsub(/[^0-9.]/, ''))
    end
    if vuln_ver.include? '<' ##There's no nice way to do >=, should really
      if vuln_ver.include? '<='; return (Gem::Version.new(dep_ver_tidy) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(dep_ver_tidy) == Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')))
      else return Gem::Version.new(dep_ver_tidy) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))
      end
    end
  end
  #
  # def self.is_within_minor_ver(gem_ver,patch_ver)
  #   return patch_ver.to_s.tr('>=<~ ', '')[0,3] == gem_ver.to_s.tr('>=<~ ', '')[0,3]
  # end

  def self.query_pypi(dep_name)
    url = "https://pypi.python.org/pypi/#{dep_name}/json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)['info']['version']
  end

  def self.get_latest_version(dep_name) # todo fix this horrible implementation
    $py = Hash.new if $py.nil?
    if  $py[dep_name].nil? or ((Time.now.to_i - $py[dep_name][1].to_i)> MsgConstants::TIMEOUT)
      $py[dep_name] = [query_pypi(dep_name), Time.now.to_i]
    end
    $py[dep_name][0]
  end




end

