require 'rss'
require 'open-uri'
require 'net/http'
require 'json'

class PomVersionLogic

  def self.is_vuln?(dep_ver,vuln_ver,fixed_in)
    vuln = false
    vuln_ver.each { |ver|
      if self.affected?(ver, dep_ver)
         vuln=true; break;
      end
    }
    fixed_in.each { |fixed_ver|
      if affected?(fixed_ver,dep_ver)
        vuln=false; break;
      end
    }
    vuln
  end

  def self.affected?(vuln_ver,dep_ver)
    return_val = vuln_ver.include?(',') ? self.comma_split(vuln_ver,dep_ver) : self.version_logic_vuln?(vuln_ver, dep_ver)
    return_val
  end

  def self.comma_split(vuln_ver,dep_ver) # method to deal with case where given double version
    first_ver = vuln_ver.rpartition(',')[0]
    second_ver = vuln_ver.rpartition(',')[2]
    case first_ver
      when />/
        second_ver = first_ver.include?('>=') ? '>='.concat(second_ver)  : '>'.concat(second_ver);
      when /</
        second_ver = first_ver.include?('<=') ? '<='.concat(second_ver)  : '<'.concat(second_ver);
      else
        Logger.new(STDOUT).debug 'Invalid vuln ver'
    end
    self.version_logic_vuln?(first_ver, dep_ver) || self.version_logic_vuln?(second_ver, dep_ver)
  end

  def self.version_logic_vuln?(vuln_ver,dep_ver) # Method to handle java version logic
    case vuln_ver
      when /<=/
        return (Gem::Version.new(dep_ver) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))) || (Gem::Version.new(dep_ver) == Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')))
      when /</
        return Gem::Version.new(dep_ver) < Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))
      when />=/
        return Gem::Version.new(dep_ver) > Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')) || (Gem::Version.new(dep_ver) == Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, '')))
      when />/
        return Gem::Version.new(dep_ver) > Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))
      when /==/
        return Gem::Version.new(dep_ver) == Gem::Version.new(vuln_ver.gsub(/[^0-9.]/, ''))
      else
        Logger.new(STDOUT).debug 'Invalid vuln ver'
    end
  end

  def self.query_maven(dep_name) # Query maven to get latest version for a dependency
      last_index = dep_name.rindex('.')
      group_id = dep_name[0..last_index-1]
      artifact_id = dep_name[last_index+1..dep_name.length-1]
      JSON.parse(Net::HTTP.get( URI("http://search.maven.org/solrsearch/select?q=g:%22#{group_id}%22+AND+a:%22#{artifact_id}%22&core=gav&rows=20&wt=json")))['response']['docs'][0]['v']
  end

  def self.get_latest_version(dep_name) # Check cache for latest version, if non existing call maven
    begin
      $p = Hash.new if $p.nil?
      if  $p[dep_name].nil? or ((Time.now.to_i - $p[dep_name][1].to_i)> MsgConstants::TIMEOUT)
        $p[dep_name] = [query_maven(dep_name), Time.now.to_i]
      end
      return $p[dep_name][0]
      rescue StandardError => e
        return MsgConstants::LATEST_VER_ERROR
    end
  end

end

