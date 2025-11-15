class Training
  def initialize(val_i)
    val_i ||= 47
    data_dir=File.expand_path('../../../lib/data', __FILE__)
    p base_name="STEP-#{val_i}.txt"
    file_name=File.join(data_dir,base_name)

    @period = 60
    @counter = 0

    @time_flag=true
    print_keyboard
    start_time,data = init_proc(file_name)
    return if start_time.nil?
    #size_training(file_name,data,start_time)
    time_training(base_name,data,start_time)
  end

  # count correct spelling
  def counter(word1,word2)
    ws1=word1.split(/\s+/)
    ws2=word2.split(/\s+/)
    i,j=0,0
    while (i < ws1.length) && (j < ws2.length) do
      if ws1[i] == ws2[j] then
        @counter+=1
      end
      i+=1
      j+=1
    end
    puts @counter
  end

  # time loop
  def loop_thread(sec)
    Thread.start(sec) do |wait_time|
      sleep wait_time
      puts "\a Time up. Type return-key to finish.."
      @time_flag=false
    end
  end

  # print key positions
  def print_keyboard
    content = <<-EOF
 q \\ w \\ e \\ r t \\ y u \\ i \\ o \\ p
  a \\ s \\ d \\ f g \\ h j \\ k \\ l \\ ; enter
sh z \\ x \\ c \\ v b \\ n m \\ , \\\ . \\  shift
EOF
    print content
  end

  def init_proc(file_name)
    data=File.readlines(file_name)
    data.each{|word| print word }
    print "\nRepeat above sentences. Type return-key to start."
    line=STDIN.gets
    if line.nil?
      # 入力がなければnilを返して呼び出し元で処理
      return nil, data
    end
    line = line.chomp
    start_time = Time.now
    return start_time, data
  end

  def keep_record(start_time, file_name, period)
    # テスト環境なら記録しない
    return if ENV['TEST'] == 'true'

    data_file = open(Shunkuntype::TRAINING_FILE, "a+")
    data_file << "#{start_time},#{file_name},#{@counter},#{period}\n"
    exit
  end

  def type_loop(data)
    data.each do |sentence|
      break if @time_flag == false
      puts sentence
      line = STDIN.gets
      break if line.nil?
      line = line.chomp
      counter(sentence, line)
    end
  end

  def size_training(file_name,data,start_time)
    type_loop(data)
    exit_proc(start_time,file_name,(Time.now-start_time).to_i)
    return
  end

  def time_training(base_name,data,start_time)
    loop_thread(@period)
    data2=[]
    20.times{ data2 << data }
    type_loop(data2.flatten)
    keep_record(start_time,base_name,@period)
  end
end
