# app/lib/MsgConstants.rb
class MsgConstants
  # Class to deal with constants across the application

  # Login/Signup
  INVALID_CREDS='Invalid credentials'
  INVALID_TOKEN='Invalid token'
  MISSING_TOKEN='Missing token'
  UNAUTHORIZED='Unauthorized request'
  ACC_CREATED='Account created'
  LOGGED_ON='Logged on. New Token generated'

  # Dependencies
  DEPENDENCIES_FOUND='Dependencies found'

  # Vulnerabilities
  VULNERABILITIES_FOUND='Vulnerabilities found'

  # Upload
  DEPENDENCY_FILE_ERROR='Validation failed when decoding dependency file.'
  UPDATE_TYPE_NOT_SUPPORTED='Update type not supported. Support versions: Safe, Latest, Manual'

  # Gem Scanning
  GEMFILE_UPLOADED = 'Ruby Gemfile'

  # Pom Scanning
  POMFILE_UPLOADED = 'Java Pomfile'

  # Pip Scanning
  PIPFILE_UPLOADED = 'Python Pip Dependencies file'

  # Generic Errors
  VALIDATION_ERROR='Validation error in one or more parameters'
  NOT_FOUND='Not found'

  # Mime types
  MIME_TEXT = 'application/txt'
  MIME_PDF = 'application/pdf'
  MIME_PLAIN = 'application/plain'
  MIME_HTML = 'text/html'

  # Filenames
  FILENAME_PDF = 'report.pdf'
  FILENAME_TXT = 'report.txt'
  FILENAME_HTML = 'report.html'

  # Reports
  TITLE = ' Scan: '
  TEXT_SAVED = 'Text report saved to: '
  PDF_SAVED = 'PDF saved to: '
  TIMESTAMP = '%d_%m_%Y_%H%M'
  NEWLINES = "\n\n\n\n"
  PATCHED_VERSION = ' Patched version: '
  TEXT_REPORT_LINE = '============================================='
  TEXT_REPORT_CVE = "CVES\n"

  # Versions
  VERSIONS = 'Versions: '
  PATCHED_VER = 'Safe: '
  LATEST_VER = 'Latest: '
  CURRENT_VER = 'Current version: '
  OVERALL_SAFE_VER = 'Overall safe version: '
  VERSION_WARNING = '    *Requires major version update'
  OUR_VERSION= 'Our version: '
  TIMEOUT = 14400
  LATEST_VER_ERROR = 'Latest version unavailable'

  # Score
  NO_CVE_SCORE = 'No CVE Score found.'
  SCORE = 'Score: '

  # Hex
  YELLOW = 'FF4500'
  RED = 'FF0000'
  GREEN = '32CD32'
  GREY = 'A9A9A9'
  DEFAULT = 'FFA500'

  # DB
  BASE_LOC = '/tmp/dependensee/'
  UPDATING = 'Updating '

  # Exploit DB
  EXPLOIT_DB_NAME = 'Exploit DB'
  EXPLOIT_DB_LOC = 'exploit_db'
  EXPLOIT_DB_GIT_URL = 'https://github.com/offensive-security/exploit-database.git'

  # Exploit DB Mappings
  EXPLOIT_MAPPING_SITE = 'cve.mitre.org'
  EXPLOIT_MAPPING_SITE_LOC = '/data/refs/refmap/allrefmaps.zip'
  EXPLOIT_MAPPING_DOWNLOAD_LOC = '/mapping.zip'
  EXPLOIT_MAPPING_UNZIP_LOC = '/mappings/'
  EXPLOIT_MAPPING_FILE_NAME = 'source-EXPLOIT-DB.html'

  # Gem DB
  GEM_DB_NAME = 'Ruby CVE DB'
  GEM_DB_LOC = 'ruby_cve'
  GEM_DB_GIT_URL ='https://github.com/rubysec/ruby-advisory-db.git'

  # Maven Pip DB
  MAVEN_PIP_DB_NAME = 'Maven/Pip CVE DB'
  MAVEN_PIP_DB_LOC = 'maven_pip_db'
  MAVEN_PIP_DB_GIT_URL = 'https://github.com/victims/victims-cve-db.git'

  # Locations Report
  BASE_REPORT = '/tmp/dependensee/reports/'
end