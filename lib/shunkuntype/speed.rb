require "shunkuntype"
require_relative "db"  # 追加

class SpeedCheck
  attr_reader :number, :period

  def initialize
    @number = 20 #default 20
    @period = 60
    check_data_files
    data = mk_random_words
    t0, t1, count = exec_speed_check(data)
    # ここでnilチェック
    if t0.nil? || t1.nil?
      puts "Speed check was interrupted or no input was given."
      return
    end
    keep_record(t0, t1, count)
  end

  def print_keyboard
    Shunkuntype.print_keyboard
  end

  def check_data_files
    retried = false
    begin
      file = open(Shunkuntype::SPEED_FILE, "r")
      if file
        puts "#{Shunkuntype::SPEED_FILE} opened succcessfully"
      end
    rescue
      if retried
        puts "Failed to create #{Shunkuntype::SPEED_FILE}. Please check permissions."
        exit 1
      end
      puts "#{Shunkuntype::SPEED_FILE} does not exist in this directory. Creating required files..."
      DataFiles.prepare
      retried = true
      retry
    end
  end

  def mk_random_words
    data=[]
    data_dir=File.expand_path('../../../lib/data', __FILE__)
    file=open("#{data_dir}/word.list",'r')
    while word=file.gets do
      data << word.chomp
    end
    data.shuffle!
    data.each do |word|
      print word+" "
    end
    return data
  end

  def exec_speed_check(data)
    print "\n\n"+number.to_s+" words should be cleared."
    print "\nType return-key to start."
    p ''
    line = $stdin.gets
    return [nil, nil, nil] if line.nil?  # breakの代わりにreturnで早期リターン
    line = line.chomp

    t0 = Time.now
    count = 0
    @number.times do |i|
      print_keyboard()
      puts (i+1).to_s
      word = data[i]
      count += word.length
      while line != word do
        puts word
        p ''
        line = $stdin.gets
        return [t0, Time.now, count] if line.nil?  # ここもnilチェック
        line = line.chomp
      end
    end
    t1 = Time.now
    return t0, t1, count
  end

  def keep_record(t0, t1, count)
    return if t0.nil? || t1.nil?
    # テスト環境なら記録しない
    return if ENV['TEST'] == 'true'

    statement = t0.to_s + ","
    statement << @number.to_s + ","
    statement << (t1 - t0).to_s + ","
    icount = @period / (t1 - t0) * count
    statement << icount.to_s + "\n"
    data_file = open(Shunkuntype::SPEED_FILE, "a+")
    data_file << statement
    p statement

    printf("%5.3f sec\n", Time.now - t0)
    printf("%4d characters.\n", icount)
  end
end
