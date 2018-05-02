require 'bundler'
require 'bundler/gem_tasks'
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

RSpec::Core::RakeTask.new('spec:progress') do |spec|
  spec.rspec_opts = %w(--format progress)
end

task default: :spec
