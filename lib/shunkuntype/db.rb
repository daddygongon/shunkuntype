#encoding: utf-8

require 'fileutils'
#require 'init'

module DataFiles

  def self.prepare
    speed_path = Shunkuntype::SPEED_FILE
    training_path = Shunkuntype::TRAINING_FILE

    create_file_if_not_exists(speed_path)
    create_file_if_not_exists(training_path)
  end

  def self.create_file_if_not_exists(path)
    create_file_path(path)
    unless File.exist?(path)
      File.open(path, 'w') {}  # 空ファイルを作成
      puts "Created #{path}"
    end
  end

  def self.create_file_path(path)
    FileUtils.mkdir_p File.dirname(path)
  end

  private_class_method :create_file_if_not_exists, :create_file_path
end

