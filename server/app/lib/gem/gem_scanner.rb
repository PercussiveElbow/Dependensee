require_relative 'gem_parser'
require_relative 'gem_db'
require_relative 'gem_version_logic'
require_relative '../common/vulnerability'
require_relative '../common/base_scanner'
require_relative '../msg_constants'


class GemfileScanner < BaseScanner

  def initialize(deps)
    super(deps)
  end

  def scan
    $ruby_db.update?
    vuln_hash = {}
    @deps.each do |spec|
      spec_name = spec.name
      vuln_hash[spec_name] = []
      print("\n\n" + MsgConstants::CHECKING_GEM + spec_name)
      gem_ver=spec.version
      RubyCve.where(['dependency_name = ?', spec_name]).each do |cve|
          print("\n" + '          -CVE' + cve.cve_id)
          unless check_unaffected_vers(gem_ver,cve.unaffected_versions)
            needed_patches = get_needed_patches(gem_ver, cve.patched_versions)
            vuln_hash[spec_name].push( Vulnerability::new(gem_ver,needed_patches,cve.cve_id))   unless needed_patches.nil?
          end
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
          print "\n" + MsgConstants::SAFE_PATCHED ; return nil
        else
          needed_patches.push(patched_version)
        end
      end
      needed_patches.each do |vuln|
        print "\n" + MsgConstants::VULNERABILITY_FOUND + MsgConstants::GEM_VERSION + gem_version.to_s + MsgConstants::PATCHED_VERSION + vuln.to_s + ' '
      end
    end
    needed_patches
  end

  def check_unaffected_vers(gem_version, unaffected_vers)
    unless unaffected_vers.nil? or gem_version.nil?
      unaffected_vers.each do |safe_ver|
        if GemVersionLogic::is_unaffected(gem_version, safe_ver)
          print  "\n" + MsgConstants::SAFE_UNAFFECTED
          return true
        end
      end
    end
    false
  end

end
