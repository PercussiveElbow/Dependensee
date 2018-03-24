require_relative '../msg_constants'
require_relative 'base_report'
require_relative 'latest_version'

class GenerateReport < BaseReport

  def self.gen_txt(project_name, vuln_list,project_language)
    filename =  self.add_dir_return_filename + '.txt'
    open(filename, 'a') { |file|
      file.puts(GenerateReport::get_title(project_name) + "\n")
      vuln_list.each do |dep, vulns|
        file.puts(dep + "\n\n")
        file.puts(MsgConstants::OUR_VERSION + vulns['cves'][0].instance_variable_get('@our_version') + MsgConstants::PATCHED_VERSION + vulns['overall_patch'].to_s + ' ' +  MsgConstants::LATEST_VER + ' ' + LatestVersion::get_latest(project_language,dep) + "\n")
        file.puts("CVES\n")
        file.puts('=============================================')
        GenerateReport::gen_txt_insert_cves(file,vulns,project_language)
        file.puts('=============================================')
      end
    }
    Logger.new(STDOUT).info  MsgConstants::TEXT_SAVED + filename
    filename
  end

  def self.gen_txt_insert_cves(file,vulns,project_language)
    for vuln in vulns['cves'] do
      cve_info =  GenerateReport::get_cve_info(project_language,vuln)
      file.puts('CVE: ' + vuln.cve + "\n")
      file.puts(MsgConstants::SCORE + cve_info.cvss2.to_s + "\n")
      file.puts(MsgConstants::OUR_VERSION + vuln.our_version + MsgConstants::PATCHED_VERSION + vuln.patched_version.to_s + "\n" )
      file.puts(cve_info.desc + "\n") if !cve_info.desc.nil?
    end
  end

  def self.gen_pdf(project_name,vuln_list,project_language)
    filename = self.add_dir_return_filename + '.pdf'
    Prawn::Document.generate(filename) do |pdf|
      pdf.draw_text GenerateReport::get_title(project_name), :at => [10, 700], :size => 26
      pdf.text MsgConstants::NEWLINES
      vuln_list.each do |dep,vulns|
        GenerateReport::gen_pdf_insert_versions(pdf,vulns,dep, project_language)
        GenerateReport::gen_pdf_insert_cves(pdf,vulns,project_language)
      end
    end
    Logger.new(STDOUT).info MsgConstants::PDF_SAVED + filename
    filename
  end

  def self.gen_pdf_insert_score(pdf,cve_info)
    cve_score= cve_info.cvss2
    cve_color = GenerateReport::get_color(cve_score)

    if cve_score.nil?;
      pdf.text MsgConstants::SCORE + MsgConstants::NO_CVE_SCORE, :color => MsgConstants::GREY, :indent_paragraphs => 40
    else
      pdf.text MsgConstants::SCORE + cve_score.to_s, :color => cve_color, :size => 16, :indent_paragraphs => 40
    end
  end

  def self.gen_pdf_insert_cves(pdf,vulns,project_language)
    for vuln in vulns['cves'] do
      pdf.text 'CVE ' + vuln.cve, :indent_paragraphs => 20, :size => 18
      cve_info = GenerateReport::get_cve_info(project_language, vuln)
      GenerateReport::gen_pdf_insert_score(pdf,cve_info)
      GenerateReport::gen_pdf_insert_patched_vers(pdf,vuln)
      desc = cve_info.desc.nil? ? '' : cve_info.desc
      pdf.text "\n" + desc + "\n\n", :style => :italic, :indent_paragraphs => 40
    end
  end

  def self.gen_pdf_insert_versions(pdf,vulns,dep,project_language)
    pdf.text dep ,:size => 25
    pdf.text 'Current version: ' + vulns['cves'][0].instance_variable_get('@our_version') +"\n", :size => 16, :color => MsgConstants::RED
    pdf.text 'Overall safe version: ' + vulns['overall_patch'] +"\n", :size => 16, :color => MsgConstants::GREEN
    pdf.text MsgConstants::LATEST_VER + ' ' + LatestVersion::get_latest(project_language,dep) + "\n\n", :size => 16
  end

  def self.gen_pdf_insert_patched_vers(pdf,vuln)
    pdf.text MsgConstants::VERSIONS, :indent_paragraphs => 40, :size => 16
    if !vuln.patched_version.nil?
      vuln.patched_version.each do |patched_ver_index|
        if GemVersionLogic::is_within_minor_ver(patched_ver_index, vuln.our_version)
          pdf.text MsgConstants::PATCHED_VER + patched_ver_index.to_s, :indent_paragraphs => 60
        else
          pdf.text MsgConstants::PATCHED_VER + patched_ver_index.to_s + MsgConstants::VERSION_WARNING, :indent_paragraphs => 60
        end
      end
    end
  end

  def self.gen_html(project_name,vuln_list,project_language)

  end


  def self.get_cve_info(language, vuln)
    case language
      when 'Java'
        return JavaCve.where(['cve_id = ?', vuln.cve.to_s]).first
      when 'Ruby'
        return RubyCve.where(['cve_id = ?', vuln.cve.to_s]).first
      when 'Python'
         return PythonCve.where(['cve_id = ?', vuln.cve.to_s]).first
      else
        # raise(Error.new)
    end
  end

  def self.get_color(cve_score)
    if cve_score.to_f >= 5.0 and cve_score.to_f <7.5
      return MsgConstants::YELLOW
    elsif cve_score.to_f >= 7.5
      return MsgConstants::RED
    else
      return MsgConstants::DEFAULT
    end
  end

  def self.get_title(project)
    return project + ' ' +  MsgConstants::TITLE + DateTime.now.strftime('%d/%m/%Y  %H:%M')
  end

end