require_relative '../common/base_report'
require_relative '../msg_constants'

class GemReport < BaseReport

  def self.gen_txt(vulnlist,language)
    filename =  self.add_dir_return_filename + '.txt'

    vulnlist.each do |dep, vulns|
      open(filename, 'a') { |file|
        vulns['cves'].each { |vuln|
          file.puts(dep + "\n")
          #TODO REPLACE WITH LESS HACKY IMPLEMENTATION
          if language == 'Java'
            cve_info = JavaCve.where(['cve_id = ?', vuln.cve.to_s]).first
          elsif language == 'Ruby'
            cve_info = RubyCve.where(['cve_id = ?', vuln.cve.to_s]).first
          elsif language == 'Python'
            cve_info = PythonCve.where(['cve_id = ?', vuln.cve.to_s]).first
          else
            # raise(Error.new)
          end
          file.puts(vuln.cve + "\n")
          file.puts(cve_info.cvss2.to_s + "\n")
          file.puts(MsgConstants::GEM_VERSION + vuln.our_version + MsgConstants::PATCHED_VERSION + vuln.patched_version.to_s + "\n")
          file.puts(cve_info.desc + "\n")
        }
      }
    end
    print MsgConstants::NEWLINES + MsgConstants::TEXT_SAVED + filename + "\n"
    filename
  end

  def self.gen_pdf(vulnlist,language)
    filename = self.add_dir_return_filename + '.pdf'
    Prawn::Document.generate(filename) do
      font_size(35) { draw_text MsgConstants::TITLE + DateTime.now.strftime('%d/%m/%Y  %H:%M'), :at => [70, 700] }
      text MsgConstants::NEWLINES
      last_gem = ''
      vulnlist.each do |dep,vulns|
        current_gem = dep
        text current_gem ,:size => 25 if current_gem != last_gem or last_gem.nil?

        vulns['cves'].each { |vuln|
          text 'CVE ' + vuln.cve, :indent_paragraphs => 20, :size => 18


          #TODO REPLACE WITH LESS HACKY IMPLEMENTATION
          if language == 'Java'
            cve_info = JavaCve.where(['cve_id = ?', vuln.cve.to_s]).first
          elsif language == 'Ruby'
            cve_info = RubyCve.where(['cve_id = ?', vuln.cve.to_s]).first
          elsif language == 'Python'
            cve_info = PythonCve.where(['cve_id = ?', vuln.cve.to_s]).first
          else
            # raise(Error.new)
          end

          last_gem=current_gem
          cve_color= MsgConstants::DEFAULT

          cve_score= cve_info.cvss2
          if cve_score.to_f >= 5.0 and cve_score.to_f <7.5
            cve_color= MsgConstants::YELLOW
          elsif cve_score.to_f >= 7.5
            cve_color=MsgConstants::RED
          end

          # CVE SCORE
          if cve_score.nil?;
            text MsgConstants::SCORE + MsgConstants::NO_CVE_SCORE, :color => MsgConstants::GREY, :indent_paragraphs => 40
          else
            text MsgConstants::SCORE + cve_score.to_s, :color => cve_color, :size => 16, :indent_paragraphs => 40
          end

          text MsgConstants::VERSIONS, :indent_paragraphs => 40, :size => 16
          gem_name = current_gem
          latest_ver = ''
          # latest_ver = GemVersionLogic::get_latest_version(gem_name)


          # if latest_ver.nil?
          #   latest_ver= ' '
          # end
          # text GEMFILE_VER + vuln.our_version  + '     ' + LATEST_VER  + latest_ver +" <link href='https://rubygems.org/gems/#{gem_name}/'>(Update here)</link>", :inline_format => true ,:indent_paragraphs => 60

          vuln.patched_version.each do |patched_ver_index|
            if GemVersionLogic::is_within_minor_ver(patched_ver_index, vuln.our_version)
              text MsgConstants::PATCHED_VER + patched_ver_index.to_s, :color => MsgConstants::GREEN, :indent_paragraphs => 60
            else
              text MsgConstants::PATCHED_VER + patched_ver_index.to_s + MsgConstants::VERSION_WARNING, :color => MsgConstants::RED, :indent_paragraphs => 60
            end
          end

          # GEM DESCRIPTION
          desc = cve_info.desc.nil? ? '' : cve_info.desc
          text "\n" + desc + "\n\n", :style => :italic, :indent_paragraphs => 40
        }
      end
    end
    print "\n" + MsgConstants::PDF_SAVED + filename + "\n"
    filename
  end

end