require 'minitest/autorun'
require 'open3'
require_relative 'test_helper'
# BDD tests for shunkuntype CLI:
# - Help message (-h)
# - Drill mode (-d)
# - Speed check (-c)

class TestCLI < Minitest::Test
  def test_help_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-h')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert status.success?, "Process did not exit successfully"
    assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
  end

  def test_drill_option
    input = "\n" * 3
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-d', '1', stdin_data: input)
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert_match(/STEP-1\.txt|keyboard|Repeat above sentences|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end

  def test_check_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-c')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert_match(/speed|check|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end
end
