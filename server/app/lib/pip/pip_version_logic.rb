require 'rss'
require 'open-uri'

class PipVersionLogic

  #todo check for the 2 digit occurance. check if any strings contain more than one comma
  def self.is_vuln?(dep_ver,vuln_ver,fixed_in)
    vuln = false
    vuln_ver.each { |ver|
      if PomVersionLogic::affected?(ver, dep_ver.gsub(/[^0-9.]/, ''))
        vuln=true; break;
      end
    }
    if !fixed_in.nil?
      fixed_in.each { |fixed_ver|
        if PomVersionLogic::affected?(fixed_ver,dep_ver.gsub(/[^0-9.]/, ''))
          vuln=false; break;
        end
      }
    end
    return vuln
  end

  def self.query_pypi(dep_name)
    return JSON.parse( Net::HTTP.get(URI("https://pypi.python.org/pypi/#{dep_name}/json")))['info']['version']
  end

  def self.get_latest_version(dep_name) # todo fix this horrible implementation
    $py = Hash.new if $py.nil?
    if  $py[dep_name].nil? or ((Time.now.to_i - $py[dep_name][1].to_i)> MsgConstants::TIMEOUT)
      $py[dep_name] = [query_pypi(dep_name), Time.now.to_i]
    end
    $py[dep_name][0]
  end

end

