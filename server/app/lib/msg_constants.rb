# app/lib/MsgConstants.rb
class MsgConstants
  NOT_FOUND='Not found'
  INVALID_CREDS='Invalid credentials'
  INVALID_TOKEN='Invalid token'
  MISSING_TOKEN='Missing token'
  UNAUTHORIZED='Unauthorized request'
  ACC_CREATED='Account created'
  ACC_NO_CREATED='Account not created'
  EXP_TOKEN='Token expired'
  DEPENDENCIES_FOUND='Dependencies found'
  VULNERABILITIES_FOUND='Vulnerabilities found'
  LOGGED_ON='Logged on. New Token generated'
  VALIDATION_ERROR='Validation error in one or more parameters'
  DEPENDENCY_FILE_ERROR='Validation failed when decoding dependency file.'
  UPDATE_TYPE_NOT_SUPPORTED='Update type not supported. Support versions: Safe, Latest, Manual'

  # Gem Scanning
  GEM_VERSION = 'Gem version: '
  PATCHED_VERSION = ' Patched version: '
  ERROR_NOT_FOUND = 'Error. Gemfile not found in: '
  GEMFILE_UPLOADED = 'Ruby Gemfile'

  # Pom Scanning
  POMFILE_UPLOADED = 'Java Pomfile'

  # Pip Scanning
  PIPFILE_UPLOADED = 'Python Pip Dependencies file'

  # Reports
  # General report constants
  TITLE = ' Scan: '
  TEXT_SAVED = 'Text report saved to: '
  PDF_SAVED = 'PDF saved to: '
  TIMESTAMP = '%d_%m_%Y_%H%M'
  NEWLINES = "\n\n\n\n"

  # Version constants
  VERSIONS = 'Versions: '
  GEMFILE_VER = 'Current: '
  PATCHED_VER = 'Safe: '
  LATEST_VER = 'Latest: '
  VERSION_WARNING = '    *Requires major version update'
  OUR_VERSION= 'Our version: '
  TIMEOUT = 14400

  # Score constants
  NO_CVE_SCORE = 'No CVE Score found.'
  SCORE = 'Score: '

  # Hex constants
  YELLOW = 'FF4500'
  RED = 'FF0000'
  GREEN = '32CD32'
  GREY = 'A9A9A9'
  DEFAULT = 'FFA500'

  #EXPLOIT MAPPINGS
  EXPLOIT_MAPPING_SITE = 'cve.mitre.org'
  EXPLOIT_MAPPING_SITE_LOC = '/data/refs/refmap/allrefmaps.zip'
  EXPLOIT_MAPPING_DOWNLOAD_LOC = '/mapping.zip'
  EXPLOIT_MAPPING_UNZIP_LOC = '/mappings/'
  EXPLOIT_MAPPING_FILE_NAME = 'source-EXPLOIT-DB.html'

  BASE_LOC = '/tmp/dependensee/'
end