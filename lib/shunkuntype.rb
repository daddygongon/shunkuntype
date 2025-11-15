require 'optparse'
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/finished_check"
require "shunkuntype/db"
require 'systemu'
require "shunkuntype/version"

module Shunkuntype
  DATA_DIR = File.join(ENV['HOME'], '.shunkuntype')
  TRAINING_FILE = File.join(DATA_DIR, "training_data.txt")
  SPEED_FILE = File.join(DATA_DIR, "speed_data.txt")

  def self.print_keyboard
    content = <<-EOF
 q \\ w \\ e \\ r t \\ y u \\ i \\ o \\ p
  a \\ s \\ d \\ f g \\ h j \\ k \\ l \\ ; enter
sh z \\ x \\ c \\ v b \\ n m \\ , \\\ . \\  shift
EOF
    print content
  end
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
