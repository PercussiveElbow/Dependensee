require 'rss'
require 'open-uri'
require 'net/http'
require 'json'

class PomVersionLogic

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
    if vuln_ver.include? '<' ##There's no nice way to do >=, should really
      if vuln_ver.include? '<='; return (Gem::Version.new(dep_ver) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))) | (Gem::Version.new(dep_ver) == Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')))
      else return Gem::Version.new(dep_ver) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))
      end
    end
  end
  #
  # def self.is_within_minor_ver(gem_ver,patch_ver)
  #   return patch_ver.to_s.tr('>=<~ ', '')[0,3] == gem_ver.to_s.tr('>=<~ ', '')[0,3]
  # end


  def self.query_maven(dep_name)
    last_index = dep_name.rindex('.')
    group_id = dep_name[0..last_index-1]
    artifact_id = dep_name[last_index+1..dep_name.length-1]

    url = "http://search.maven.org/solrsearch/select?q=g:%22#{group_id}%22+AND+a:%22#{artifact_id}%22&core=gav&rows=20&wt=json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)['response']['docs'][0]['v']
  end

  def self.get_latest_version(dep_name) # todo fix this horrible implementation
    $p = Hash.new if $p.nil?
    if  $p[dep_name].nil? or ((Time.now.to_i - $p[dep_name][1].to_i)> MsgConstants::TIMEOUT)
      $p[dep_name] = [query_maven(dep_name), Time.now.to_i]
    end
    $p[dep_name][0]
  end

end

