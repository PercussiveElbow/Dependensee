require_relative 'base_report'
require_relative 'latest_version'

class GenerateReport < BaseReport

  # PLAINTEXT GENERATION METHODS
  def self.gen_txt(project_name, vuln_list,project_language) # Method to generate text report
    filename =  self.add_dir_return_filename + '.txt'
    open(filename, 'a') { |file|
      file.puts(GenerateReport::get_title(project_name) + "\n")
      vuln_list.each do |dep, vulns|
        file.puts(dep + "\n\n")
        file.puts(MsgConstants::OUR_VERSION + vulns['cves'][0].instance_variable_get('@our_version') + MsgConstants::PATCHED_VERSION + vulns['overall_patch'].to_s + ' ' +  MsgConstants::LATEST_VER + ' ' + LatestVersion::get_latest(project_language,dep) + "\n")
        GenerateReport::gen_txt_insert_cves(file,vulns,project_language)
      end
    }
    Logger.new(STDOUT).info  MsgConstants::TEXT_SAVED + filename
    filename
  end

  def self.gen_txt_insert_cves(file,vulns,project_language) # Txt helper method to insert CVEs
    file.puts(MsgConstants::TEXT_REPORT_CVE)
    file.puts(MsgConstants::TEXT_REPORT_LINE)
    vulns['cves'].each { |vuln|
      cve_info = GenerateReport::get_cve_info(project_language, vuln)
      file.puts('CVE: ' + vuln.cve + "\n")
      file.puts(MsgConstants::SCORE + cve_info.cvss2.to_s + "\n")
      file.puts(MsgConstants::OUR_VERSION + vuln.our_version + MsgConstants::PATCHED_VERSION + vuln.patched_version.to_s + "\n")
      file.puts(cve_info.desc + "\n") unless cve_info.desc.nil?
    }
    file.puts(MsgConstants::TEXT_REPORT_LINE)
  end



  # PDF GENERATION
  def self.gen_pdf(project_name,vuln_list,project_language) # Method to generate PDF report
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

  def self.gen_pdf_insert_score(pdf,cve_info) # Method to write score to pdf with correct color
    cve_score= cve_info.cvss2
    cve_color = GenerateReport::gen_pdf_get_color(cve_score)

    if cve_score.nil?;
      pdf.text MsgConstants::SCORE + MsgConstants::NO_CVE_SCORE, :color => MsgConstants::GREY, :indent_paragraphs => 40
    else
      pdf.text MsgConstants::SCORE + cve_score.to_s, :color => cve_color, :size => 16, :indent_paragraphs => 40
    end
  end

  def self.gen_pdf_insert_cves(pdf,vulns,project_language) # Method to write CVEs to pdf
    vulns['cves'].each { |vuln|
      pdf.text 'CVE ' + vuln.cve, :indent_paragraphs => 20, :size => 18
      cve_info = GenerateReport::get_cve_info(project_language, vuln)
      GenerateReport::gen_pdf_insert_score(pdf, cve_info)
      GenerateReport::gen_pdf_insert_patched_vers(pdf, vuln)
      desc = cve_info.desc.nil? ? '' : cve_info.desc
      pdf.text "\n" + desc + "\n\n", :style => :italic, :indent_paragraphs => 40
    }
  end

  def self.gen_pdf_insert_versions(pdf,vulns,dep,project_language) # Method to write relevant version info to pdf
    pdf.text dep ,:size => 25
    pdf.text MsgConstants::CURRENT_VER + vulns['cves'][0].instance_variable_get('@our_version') +"\n", :size => 16, :color => MsgConstants::RED
    pdf.text MsgConstants::OVERALL_SAFE_VER + vulns['overall_patch'] +"\n", :size => 16, :color => MsgConstants::GREEN
    pdf.text MsgConstants::LATEST_VER + ' ' + LatestVersion::get_latest(project_language,dep) + "\n\n", :size => 16
  end

  def self.gen_pdf_insert_patched_vers(pdf,vuln) # Method to write patched version info to pdf
    pdf.text MsgConstants::VERSIONS, :indent_paragraphs => 40, :size => 16
    unless vuln.patched_version.nil?
      vuln.patched_version.each do |patched_ver_index|
        if GemVersionLogic::is_within_minor_ver(patched_ver_index, vuln.our_version)
          pdf.text MsgConstants::PATCHED_VER + patched_ver_index.to_s, :indent_paragraphs => 60
        else
          pdf.text MsgConstants::PATCHED_VER + patched_ver_index.to_s + MsgConstants::VERSION_WARNING, :indent_paragraphs => 60
        end
      end
    end
  end

  def self.gen_pdf_get_color(cve_score) # Method to get correct color
    if cve_score.to_f >= 5.0 and cve_score.to_f <7.5
      return MsgConstants::YELLOW
    elsif cve_score.to_f >= 7.0
      return MsgConstants::RED
    else
      return MsgConstants::DEFAULT
    end
  end


  # HTML GENERATION
  def self.gen_html(project_name,vuln_list,lang) # Method to generate HTML report
    template = ERB.new(File.open(Rails.root.join('app','views','reports','reports.html.erb')).read)
    a = binding
    a.local_variable_set(:lang,lang)
    vuln_list = GenerateReport::gen_html_cve_info(lang,vuln_list)
    a.local_variable_set(:vuln_list,vuln_list)
    a.local_variable_set(:project_name,GenerateReport::get_title(project_name))
    template.result(a)
    end

  def self.gen_html_cve_info(lang,vuln_list) # Method to get CVE info for HTML report
    vuln_list.each do |dep,vulns|
      vulns['latest_ver'] = LatestVersion::get_latest(lang,dep)
      i =0
      while i < vulns['cves'].length
        cve_info = GenerateReport::get_cve_info(lang,vulns['cves'][i])
        vulns['cves'][i] = vulns['cves'][i].as_json
        vulns['cves'][i]['score'] unless cve_info.cvss2.nil?
        vulns['cves'][i]['desc'] = cve_info.desc unless cve_info.desc.nil?
        i = i+1
      end
    end
    vuln_list
  end

end