property :python_path, String, default: 'python'
property :package_name, String, name_property: true # Name of the package
property :package_url, String, desired_state: false # URL of package location. Optional, used to specify git locations etc
property :version, String, default: nil # Package to install. Defaults to "latest"
property :virtualenv, String, desired_state: false # Venv
property :timeout, Fixnum, deafult: 900, desired_state: false
property :user, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
property :environment, Hash, desired_state: false
property :options, Array, default: [], desired_state: false # Additional options for installation

default_action :install

require 'chef/mixin/shell_out'

def real_python_path
  if virtualenv
    "#{virtualenv}/bin/python"
  else
    python_path
  end
end

def pip_command(subcommand)
  options = { :timeout => timeout, :user => user, :group => group }
  environment = Hash.new
  environment['HOME'] = Dir.home(user) if user
  environment.merge!(environment) if environment && !environment.empty?
  options[:environment] = environment
  # Append pip starter to subcommand
  subcommand=subcommand.clone()
  if subcommand.class==Array
    subcommand.unshift(real_python_path,'-m','pip.__main__')
  elsif subcommand.class==String
    subcommand=real_python_path+' -m pip.__main__ '+subcommand
  else
    raise 'Invalid subcommand type. Supply Array or String'
  end

  shell_out!(subcommand, options)
end

load_current_value do
  # Use the python path to find the current version of the module
  under_package_name = package_name.gsub('_', '-')
  pattern = Regexp.new("^#{Regexp.escape(under_package_name)} \\(([^)]+)\\)$", true)
  my_line = pip_command('list').stdout.lines.map{|line| pattern.match(line)}.compact.first
  if my_line
    version my_line[1]
  else
    # No such package installed
    current_value_does_not_exist!
  end
end

action :install do
  args = if package_url
           # We have a url to install from
           ['install',package_url]
         elsif version.nil?
           # We have no specific version
           ['install', package_name]
         elsif current_value and current_value.version == version
           # We have the current version
           nil
         else
           # We have a specific version
           ['install', "#{package_name}==#{version}"]
         end
  if args
    converge_by "Installing backslasher_python_pip #{package_name}" do
      pip_command(args)
    end
  end
end

def should_remove?
  if current_value.nil?
    # Nothing installed
    false
  elsif version.nil?
    # Something is installed, remove it
    true
  elsif version == current_resrouce.version
    # We're supposed to remove a version, and this is it
    true
  else
    # We're supposed to remove a version, and this is not it
    false
  end
end

action :remove do
  if should_remove? # ~FC023
    converge_by "Removing backslasher_python_pip #{package_name}" do
      pip_command(['uninstall','--yes',package_name])
    end
  end
end

action :upgrade do
  # Upgrading
  if current_value.nil? or (current_value.version != version) # ~FC023
    converge_by "Upgrading backslasher_python_pip" do
      pip_command(['install','--upgrade',package_name])
    end
  end
end
