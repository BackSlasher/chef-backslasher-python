property :python_path, String, default: 'python'
property :package_name, String, name_property: true # Name of the package
property :package_url, String, default: nil # URL of package location. Optional, used to specify git locations etc
property :version, String, default: nil # Package to install. Defaults to "latest"
property :virtualenv, String, default: nil
property :timeout, Fixnum, deafult: 900
property :user, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
property :environment, Hash
property :options, Array, default: [] # Additional options for installation

require 'chef/mixin/shell_out'

def real_python_path
  if virtualenv
    "#{virtualenv}/bin/python"
  else
    python_path
  end
end

def pip_command(subcommand)
  options = { :timeout => new_resource.timeout, :user => new_resource.user, :group => new_resource.group }
  environment = Hash.new
  environment['HOME'] = Dir.home(new_resource.user) if new_resource.user
  environment.merge!(new_resource.environment) if new_resource.environment && !new_resource.environment.empty?
  # Append pip starter to subcommand
  subcommand=subcommand.clone()
  if subcommand.class==Array
    subcommand.unshift('-m','pip')
  elsif subcommand.class==String
    subcommand='-m pip '+subcommand
  else
    raise 'Invalid subcommand type. Supply Array or String'
  end

  shell_out!(subcommand, options)
end

load_current_value do
  # Use the python path to find the current version of the module
  pattern = Regexp.new("^#{Regexp.escape(new_resource.package_name)} \\(([^)]+)\\)$", true)
  my_line = pip_command('freeze').stdout.lines.find{|line| pattern.match(line)}
  if my_line
    version my_line[1]
  else
    # No such package installed
    current_value_does_not_exist!
  end
end

action :install do
  if new_resource.package_url
    # We have a url to install from
    args=['install',new_resource.package_url]
  elsif new_resource.version.nil?
    # We have no specific version
    args=['install', new_resource.package_name]
  else
    # We have a specific version
    args=['install', "#{new_resrouce.package_name}==#{new_resource.version}"]
  end
  converge_by "Installing backslasher_python_pip #{new_resrouce.package_name}" do
    pip_command(args)
  end
end

def should_remove?
  if current_resource.version.nil?
    # Nothing installed
    false
  elsif new_resource.version.nil?
    # Something is installed, remove it
    true
  elsif new_resource.version == current_resrouce.version
    # We're supposed to remove a version, and this is it
    true
  else
    # We're supposed to remove a version, and this is not it
    false
  end
end

action :remove do
  if should_remove?
    converge_by "Removing backslasher_python_pip #{new_resource.package_name}" do
      pip_command(['uninstall','--yes',new_resource.package_name])
    end
  end
end

action :upgrade do
  # Upgrading
  if current_resource.version.nil? or (current_resource.version != new_resource.version)
    converge_by "Upgrading backslasher_python_pip #{args}" do
      pip_command(['install','--upgrade',new_resource.package_name])
    end
  end
end