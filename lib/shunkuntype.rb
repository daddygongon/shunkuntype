require 'optparse'
require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/finished_check"
require "shunkuntype/mk_summary"
require "shunkuntype/db"
require "shunkuntype/merge"
require 'systemu'

module Shunkuntype
  TRAINING_FILE = File.expand_path('../../../training_data.txt', __FILE__)
  SPEED_FILE = File.expand_path('../../../speed_data.txt', __FILE__)
end

class Command

  def self.run(argv=[])
    print "Shunkuntype says 'Hello world'.\n"
    new(argv).execute
  end

  def initialize(argv=[])
    @argv = argv
  end

  def execute
    DataFiles.prepare

    @argv << '--help' if @argv.size==0
    command_parser = OptionParser.new do |opt|
      opt.on('-v', '--version','show program Version.') { |v|
        opt.version = Shunkuntype::VERSION
        puts opt.ver
      }
      opt.on('-c', '--check','Check speed') {|v| SpeedCheck.new }
      opt.on('-d', '--drill [VAL]','one minute Drill [VAL]', Integer) {|v| Training.new(v) }
      opt.on('-h', '--help','show help message') { puts opt; exit }
      opt.on('-l','--log','view training log') {|v| FinishCheck.new }
    end
    command_parser.parse!(@argv)
    exit
  end
end
