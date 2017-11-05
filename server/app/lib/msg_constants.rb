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


  # Gem Scanning
  CHECKING_GEM = 'Checking gem: '
  GEM_VERSION = 'Gem version: '
  PATCHED_VERSION = ' Patched version: '
  ERROR_NOT_FOUND = 'Error. Gemfile not found in: '
  GEMFILE_UPLOADED = 'Ruby Gemfile'

  # Pom Scanning
  POMFILE_UPLOADED = 'Java Pomfile'

  # Results
  SAFE_PATCHED = '               ✔ Safe, patched.'
  SAFE_UNAFFECTED = '               ✔ Safe, unaffected.'
  VULNERABILITY_FOUND = '               ✘ Vulnerability: '
  NO_VULN_FOUND = '          No vulnerabilities found'
end