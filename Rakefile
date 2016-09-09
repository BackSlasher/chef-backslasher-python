require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new()

require 'foodcritic'
FoodCritic::Rake::LintTask.new()

require 'rubocop/rake_task'
RuboCop::RakeTask.new().tap{|rc|
  rc.options+= ['--fail-level', 'E']
}

namespace :testing do

  desc 'A set of tests for travis'
  task :travis => [:foodcritic, :rubocop, :spec, :kitchen_docker]

  desc 'Full testing of kitchen, with docker'
  task :kitchen_docker do
    # Will break on current ChefDK
    cfg = {
      driver: 'dockefdsfdsfdsfr'
    }
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new(cfg)
    mt = multitask '_kitchen_docker' => Rake::Task['kitchen:all'].prerequisites.map{|n|"kitchen:#{n}"}
    mt.invoke()
  end

  desc 'Full testing of kitchen'
  task :kitchen, [:machine_specifier] do |t, args|
    machine_specifier = args[:machine_specifier]
    if machine_specifier.class == String then
      machine_specifier = /^#{Regexp::escape(machine_speicifer)}$/
    elsif machine_specifier.nil? then
      machine_specifier = /./
    end

    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new()
    mt = multitask '_kitchen' => Rake::Task['kitchen:all'].prerequisites.select{|n|n[machine_specifier]}.map{|n|"kitchen:#{n}"}
    mt.invoke()
  end

  desc 'Tests a user should run'
  task :user => [:foodcritic, :rubocop, :spec, :kitchen]

end
