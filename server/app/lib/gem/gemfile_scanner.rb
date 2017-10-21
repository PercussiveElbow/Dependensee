require_relative 'gemfile_parser'
require_relative 'gemfile_db'
require_relative 'gem_version_logic'
require_relative '../common/vulnerability'
# require_relative '../common/report'
# require_relative 'gemfile_updater'
require_relative '../common/scanner'


class GemfileScanner < Scanner

  #TODO MOVE TO CONSTANTS
  # General
  CHECKING_GEM = 'Checking gem: '
  GEM_VERSION = 'Gem version: '
  PATCHED_VERSION = ' Patched version: '

  # Results
  SAFE_PATCHED = '               ✔ Safe, patched.'
  SAFE_UNAFFECTED = '               ✔ Safe, unaffected.'
  VULNERABILITY_FOUND = '               ✘ Vulnerability: '
  NO_VULN_FOUND = '          No vulnerabilities found for gem in DB'
  ERROR_NOT_FOUND = 'Error. Gemfile not found in: '

  def initialize(specs)
    super()
    @specs = specs
  end

  def scan_all_gems
    vuln_hash = {}
    @specs.each do |spec|
      vuln_hash[spec.instance_variable_get('@name').to_s] = []
      print("\n\n" + CHECKING_GEM + spec.instance_variable_get('@name').to_s)
      gem_ver=spec.instance_variable_get('@version').instance_variable_get('@version')
      cve_list = Cve.where(["dependency_name = ?", spec.instance_variable_get('@name').to_s])
      cve_list.each do |cve|
          print("\n" + '          -CVE' + cve.cve_id)
          # Use this messy gsub stuff until i can figure out why this field isn't storing as array
          unless check_unaffected_vers(gem_ver,cve.unaffected_versions.gsub('"','').gsub('[','').gsub(']','').split(','))
            needed_patches = get_needed_patches(gem_ver, cve.patched_versions.gsub('"','').gsub('[','').gsub(']','').split(','))
            unless needed_patches.nil?
              #need to check for dupes here
              # vuln_hash[spec.instance_variable_get('@name').to_s] << (Vulnerability::new(gem_ver, needed_patches , cve.attributes))
              vuln_hash[spec.instance_variable_get('@name').to_s].push({'Vulnerability' => Vulnerability::new(gem_ver, needed_patches , cve.attributes)})
              print cve.cve_id + 'VULN FOUND!!!'
            end
          end
      # else print("\n" + NO_VULN_FOUND)
      end
    end
    vuln_hash
  end

  def get_needed_patches(gem_version, patched_versions)
    needed_patches = Array.new
    unless gem_version.nil? or patched_versions.nil?
      patched_versions.each do |patched_version|

        if patched_version.to_s.include? ','
          # TODO add fix for weird case with commas in .yml resulting in array
          return nil
        end

        if GemVersionLogic::is_above_patched_ver(gem_version, patched_version)
          print "\n" + SAFE_PATCHED ; return nil
        else
          needed_patches.push(patched_version)
        end
      end
      needed_patches.each do |vuln|
        print "\n" + VULNERABILITY_FOUND + GEM_VERSION + gem_version.to_s + PATCHED_VERSION + vuln.to_s + ' '
      end
    end
    needed_patches
  end

  def check_unaffected_vers(gem_version, unaffected_vers)
    unless unaffected_vers.nil? or gem_version.nil?
      unaffected_vers.each do |safe_ver|
        if GemVersionLogic::is_unaffected(gem_version, safe_ver)
          print  "\n" + SAFE_UNAFFECTED
          return true
        end
      end
    end
    false
  end

end
