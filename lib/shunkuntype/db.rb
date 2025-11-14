#encoding: utf-8

require 'fileutils'
#require 'init'

module DataFiles

  def self.prepare
    data_path = File.join(ENV['HOME'], '.shunkuntype','training_data.txt')

    create_file_if_not_exists(data_path)
  end

  def self.create_file_if_not_exists(path)
    create_file_path(path)

    return if File::exist?(path)
    create_data_files
  end

  def self.create_file_path(path)
    FileUtils.mkdir_p File.dirname(path)
  end

  def self.create_data_files
    if File::exist?("./speed_data.txt") then
      system "mv ./speed_data.txt #{Shunkuntype::SPEED_FILE}"
      print "moving ./speed_data.txt #{Shunkuntype::SPEED_FILE}.\n"
    end
    if File::exist?("./training_data.txt") then
      system "mv ./training_data.txt #{Shunkuntype::TRAIN_FILE}"
      print "moving ./training_data.txt #{Shunkuntype::TRAIN_FILE}.\n"
    end
    if File::exist?(Shunkuntype::SPEED_FILE) then
      print "#{Shunkuntype::SPEED_FILE} exits.\n"
    else
      File::open(Shunkuntype::SPEED_FILE,'a')
      print "make #{Shunkuntype::SPEED_FILE}\n"
    end
    if File::exist?(Shunkuntype::TRAIN_FILE) then
      print "#{Shunkuntype::TRAIN_FILE} exits.\n"
    else
      File::open(Shunkuntype::TRAIN_FILE,'a')
      print "make #{Shunkuntype::TRAIN_FILE}\n"
    end
  end
  private_class_method :create_file_if_not_exists, :create_file_path, :create_data_files
end

