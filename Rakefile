require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  p t.pattern = FileList["test/**/test_*.rb"]
  t.verbose = true
end

task :default do
  system 'rake -T'
end

