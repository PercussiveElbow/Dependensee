require_relative '../msg_constants'
require_relative 'base_report'

class GenerateReport < BaseReport

  def self.gen_txt(project, vuln_list,language)
    filename =  self.add_dir_return_filename + '.txt'
    open(filename, 'a') { |file|
      file.puts(GenerateReport::get_title(project) + "\n")
      vuln_list.each do |dep, vulns|
        file.puts(dep + "\n\n")
        file.puts(MsgConstants::OUR_VERSION + vulns['cves'][0].instance_variable_get('@our_version') + MsgConstants::PATCHED_VERSION + vulns['overall_version'].to_s + "\n")
        file.puts("CVES\n")
        for vuln in vulns['cves'] do
          cve_info =  GenerateReport::get_cve_info(language,vuln)
          file.puts('CVE: ' + vuln.cve + "\n")
          file.puts(MsgConstants::SCORE + cve_info.cvss2.to_s + "\n")
          file.puts(MsgConstants::OUR_VERSION + vuln.our_version + MsgConstants::PATCHED_VERSION + vuln.patched_version.to_s + "\n")
          file.puts(cve_info.desc + "\n") if !cve_info.desc.nil?
        end
      end
    }
    print MsgConstants::NEWLINES + MsgConstants::TEXT_SAVED + filename + "\n"
    filename
  end

  def self.gen_pdf(project,vuln_list,language)
    filename = self.add_dir_return_filename + '.pdf'
    Prawn::Document.generate(filename) do
      font_size(30) { draw_text GenerateReport::get_title(project), :at => [30, 700] }
      text MsgConstants::NEWLINES
      vuln_list.each do |dep,vulns|
        text dep ,:size => 25
        text 'Current version: ' + vulns['cves'][0].instance_variable_get('@our_version') +"\n", :size => 16, :color => MsgConstants::RED
        text 'Overall safe version: ' + vulns['overall_patch'] +"\n\n", :size => 16, :color => MsgConstants::GREEN

        for vuln in vulns['cves'] do
          text 'CVE ' + vuln.cve, :indent_paragraphs => 20, :size => 18
          cve_info = GenerateReport::get_cve_info(language, vuln)
          cve_score= cve_info.cvss2
          cve_color = GenerateReport::get_color(cve_score)

          if cve_score.nil?;
            text MsgConstants::SCORE + MsgConstants::NO_CVE_SCORE, :color => MsgConstants::GREY, :indent_paragraphs => 40
          else
            text MsgConstants::SCORE + cve_score.to_s, :color => cve_color, :size => 16, :indent_paragraphs => 40
          end
          text MsgConstants::VERSIONS, :indent_paragraphs => 40, :size => 16
          latest_ver = ''
          # latest_ver = GemVersionLogic::get_latest_version(gem_name)

          vuln.patched_version.each do |patched_ver_index|
            if GemVersionLogic::is_within_minor_ver(patched_ver_index, vuln.our_version)
              text MsgConstants::PATCHED_VER + patched_ver_index.to_s, :indent_paragraphs => 60
            else
              text MsgConstants::PATCHED_VER + patched_ver_index.to_s + MsgConstants::VERSION_WARNING, :indent_paragraphs => 60
            end
          end
          desc = cve_info.desc.nil? ? '' : cve_info.desc
          text "\n" + desc + "\n\n", :style => :italic, :indent_paragraphs => 40
        end
      end
    end
    print "\n" + MsgConstants::PDF_SAVED + filename + "\n"
    filename
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