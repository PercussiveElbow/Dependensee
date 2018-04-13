require_relative 'gem_parser'
require_relative 'gem_db'
require_relative 'gem_version_logic'
require_relative '../common/base_scanner'

class GemScanner < BaseScanner

  def initialize(deps)
    super(deps)
  end

  def scan # Scan ruby dependencies for CVEs
    $ruby_db.update?
    vuln_hash = {}
    @deps.each do |spec|
      spec_name = spec.name
      vuln_hash[spec_name] = {} ;vuln_hash[spec_name]['cves'] = []
      gem_ver=spec.version
      vuln_hash = scan_cves(spec_name,gem_ver,vuln_hash)
    end
    GenericVersionLogic::finish_version_logic(vuln_hash)
  end

  def scan_cves(spec_name,gem_ver,vuln_hash) # search ruby cves for entries of this name, return in hash if vuln
    RubyCve.where(['dependency_name = ?', spec_name]).each do |cve|
      unless check_unaffected_vers(gem_ver,cve.unaffected_versions)
        needed_patches = get_needed_patches(gem_ver, cve.patched_versions)
        vuln_hash = insert_vuln_hash(vuln_hash,needed_patches,gem_ver,cve,spec_name)
      end
    end
    vuln_hash
  end

  def insert_vuln_hash(vuln_hash,needed_patches,gem_ver,cve,spec_name)
    vuln_hash[spec_name]['cves'].push( Vulnerability::new(gem_ver,needed_patches,cve.cve_id))   unless needed_patches.nil?
    vuln_hash
  end

  def get_needed_patches(gem_version, patched_versions) # get any patches needed
    needed_patches = Array.new
    unless gem_version.nil? or patched_versions.nil?
      patched_versions.each do |patched_version|

        return nil if patched_version.to_s.include?(',') # for weird case where there is a comma present in versioning

        if GemVersionLogic::is_above_patched_ver(gem_version, patched_version)
          return nil
        else
          needed_patches.push(patched_version)
        end
      end
    end
    needed_patches
  end

  def check_unaffected_vers(gem_version, unaffected_vers) # check if the ver is included in unaffected vers
    unless unaffected_vers.nil? or gem_version.nil?
      unaffected_vers.each do |safe_ver| return true if GemVersionLogic::unaffected?(gem_version, safe_ver) end
    end
    false
  end

end
