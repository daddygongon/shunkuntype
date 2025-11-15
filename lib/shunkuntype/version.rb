require 'fileutils'
require 'tmpdir'

module Shunkuntype
  VERSION = "1.0.16"
  data_dir = File.join(ENV['HOME'], '.shunkuntype')
  SPEED_FILE = File.join(data_dir, "speed_data.txt")
  TRAINING_FILE = File.join(data_dir, "training_data.txt")
  SERVER_FILE = File.join(data_dir, "server_data.txt")
end