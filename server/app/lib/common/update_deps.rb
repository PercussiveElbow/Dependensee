

class UpdateDeps

  def self.get_vulns(project,scan)
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

  def self.handle_safe(project,scan,vuln_list)
    vuln_list = UpdateDeps::get_vulns(project,scan) if vuln_list.nil?
    for dep_name, vulns in vuln_list
      UpdateDeps::set_update_version(scan,dep_name,vulns['overall_patch'])
    end
    scan.update_attribute(:needs_update, 'yes')
    { message: "Scan #{scan.id} vulnerable dependencies set to safe" }
  end

  def self.handle_latest(project,scan)
    vuln_list = UpdateDeps::get_vulns(project,scan)
    for dep_name, vulns in vuln_list
      UpdateDeps::set_update_version(scan,dep_name,LatestVersion::get_latest(project.language,dep_name))
    end
    scan.update_attribute(:needs_update, 'yes')
    { message: "Scan #{scan.id} vulnerable dependencies set to latest" }
  end

  def self.handle_manual(scan)
    scan.update_attribute(:needs_update, 'yes')
    { message: "Scan #{scan.id} vulnerable dependencies set to manual" }
  end

end