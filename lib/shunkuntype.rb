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
    new(argv).execute
  end

  def initialize(argv=[])
    @argv = argv
  end

  def execute
    DataFiles.prepare

    @mode = nil

    command_parser = OptionParser.new do |opt|
      opt.on('-v', '--version','show program Version.') { |v|
        opt.version = Shunkuntype::VERSION
        puts opt.ver
      }
      opt.on('-c', '--check','Check speed') {|v| SpeedCheck.new }
      opt.on('-d', '--drill [VAL]','one minute Drill [VAL]', Integer) {|v| Training.new(v) }
      opt.on('-h', '--help','show help message') { puts opt; exit }
      opt.on('-l','--log','view training log') {|v| FinishCheck.new }
      opt.on('-r MODE', '--record MODE',
        "Show record data in readable format.\n" \
        "  MODE can be:\n" \
        "  all           Show both speed and training data (default)\n" \
        "  plot          Output matplotlib code for plotting\n" \
        "  speed_data    Show only speed data\n" \
        "  training_data Show only training data"
      ) {|mode| @mode = mode }
#      opt.on('-r', '--record', 'Show both speed and training data (same as -r all)') { @mode = 'all' }
    end
    command_parser.parse!(@argv)
    # データ表示
    case @mode
    when 'plot', 'python'
      print_python_plot_code
      exit
    when 'speed_data'
      print_csv_pretty(Shunkuntype::SPEED_FILE, %w[Time Words TimeSec Score])
      exit
    when 'training_data'
      print_csv_pretty(Shunkuntype::TRAINING_FILE, %w[Time Words TimeSec Score])
      exit
    when 'all'
      print_pretty_data
      exit
    end

    @argv << '--help' if @argv.size==0
    command_parser.parse!(@argv)
    exit
  end

  private

  def print_pretty_data
    print_csv_pretty(Shunkuntype::SPEED_FILE, %w[Time Words TimeSec Score])
    print_csv_pretty(Shunkuntype::TRAINING_FILE, %w[Time Words TimeSec Score])
  end

  def print_csv_pretty(path, headers)
    if File.exist?(path)
      puts "== #{File.basename(path)} =="
      puts headers.join("\t")
      File.foreach(path) do |line|
        puts line.chomp.split(',').join("\t")
      end
      puts
    else
      puts "#{path} not found."
    end
  end

  def print_python_plot_code
    speed_path = Shunkuntype::SPEED_FILE
    training_path = Shunkuntype::TRAINING_FILE
    puts "# Python (matplotlib) code for plotting your typing data"
    puts "# Save this as plot_typing.py and run: python plot_typing.py"
    puts <<~PYTHON
      import matplotlib.pyplot as plt
      import csv
      from datetime import datetime

      def load_data(path):
          times, scores = [], []
          try:
              with open(path) as f:
                  reader = csv.reader(f)
                  for row in reader:
                      if len(row) < 4:
                          continue
                      # row[0]: time, row[2]: score
                      try:
                          t = datetime.strptime(row[0].split('.')[0], '%Y-%m-%d %H:%M:%S %z')
                          s = float(row[2])
                          times.append(t)
                          scores.append(s)
                      except Exception:
                          continue
          except FileNotFoundError:
              pass
          return times, scores

      speed_times, speed_scores = load_data("#{speed_path}")
      train_times, train_scores = load_data("#{training_path}")

      plt.figure(figsize=(10,5))
      if speed_times:
          plt.plot(speed_times, speed_scores, 'o-', label='Speed')
      if train_times:
          plt.plot(train_times, train_scores, 's-', label='Training')
      plt.xlabel('Date')
      plt.ylabel('Score')
      plt.title('Typing Progress')
      plt.legend()
      plt.grid(True)
      plt.tight_layout()
      plt.show()
    PYTHON
  end
end
