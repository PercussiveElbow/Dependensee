
class UpdateDeps

  def self.get_vulns(project,scan) # Helper method to go fetch vulns
    case project.language
      when 'Ruby'
        GemScanner::new(Dependency.where(['scan_id = ?', scan.id])).scan
      when 'Java'
        PomScanner::new(Dependency.where(['scan_id = ?', scan.id])).scan
      when 'Python'
        PipScanner::new(Dependency.where(['scan_id = ?', scan.id])).scan
    end
  end

  def self.set_update_version(scan,dep_name,update_ver)
    scan.dependencies.where(name: dep_name)[0].update(update_to: update_ver)
  end

  def self.handle_safe(project,scan,vuln_list) # Handle call to update to minimum "safe" dependencies
    vuln_list = UpdateDeps::get_vulns(project,scan) if vuln_list.nil?
    vuln_list.each { |dep_name, vulns|
      UpdateDeps::set_update_version(scan, dep_name, vulns['overall_patch'])
    }
    scan.update_attribute(:needs_update, true)
    { message: "Scan #{scan.id} vulnerable dependencies set to safe" }
  end

  def self.handle_latest(project,scan) # Handle call to update to latest dependencies
    vuln_list = UpdateDeps::get_vulns(project,scan)
    vuln_list.each { |dep_name, vulns|
      UpdateDeps::set_update_version(scan, dep_name, LatestVersion::get_latest(project.language, dep_name))
    }
    scan.update_attribute(:needs_update, true)
    { message: "Scan #{scan.id} vulnerable dependencies set to latest" }
  end

  def self.handle_manual(scan) # Handle call to manual, user has set versions to update via API
    scan.update_attribute(:needs_update, true)
    { message: "Scan #{scan.id} vulnerable dependencies set to manual" }
  end

end