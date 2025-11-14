require 'optparse'
require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/finished_check"
require "shunkuntype/mk_summary"
require "shunkuntype/db"
require "shunkuntype/merge"
require 'systemu'

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
      opt.on('-h', '--history','view training History') {|v| FinishCheck.new }
      opt.on('--reset','reset training data') { |v| reset_data()}
    end
    command_parser.parse!(@argv)
    exit
  end

  def reset_data
    data_dir = File.join(ENV['HOME'], '.shunkuntype')
    FileUtils.cd(data_dir)
    begin
      FileUtils.mkdir('old_data',:verbose => true)
    rescue Errno::EEXIST
      print "Directory 'old_data' exists at #{data_dir}.\n\n"
    end
    time=Time.now.strftime("%Y%m%d%H%M%S")
    ['speed_data','training_data'].each{|file|
      target = File.join(data_dir,'old_data',"#{file}_#{time}.txt")
      FileUtils.mv(file+'.txt',target,:verbose=>true)
    }
  end
end
