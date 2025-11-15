require 'fileutils'
require 'tmpdir'

module Shunkuntype
  VERSION = "1.1.0"
  data_dir = File.join(ENV['HOME'], '.shunkuntype')
end