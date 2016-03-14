# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

require 'chef/mixin/shell_out'

def real_python_path
  if new_resource.virtualenv
    "#{new_resource.virtualenv}/bin/python"
  else
    new_resource.python_path
  end
end

def pip_command(subcommand)
  options = { :timeout => new_resource.timeout, :user => new_resource.user, :group => new_resource.group }
  environment = Hash.new
  environment['HOME'] = Dir.home(new_resource.user) if new_resource.user
  environment.merge!(new_resource.environment) if new_resource.environment && !new_resource.environment.empty?
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

def load_current_resource
  @current_resource = Chef::Resource::BackslasherPythonPip.new(@new_resource.name)
  under_package_name = new_resource.package_name.gsub('_', '-')
  pattern = Regexp.new("^#{Regexp.escape(under_package_name)} \\(([^)]+)\\)$", true)
  my_line = pip_command('list').stdout.lines.map{|line| pattern.match(line)}.compact.first
  if my_line
    @current_resource.version (my_line[1])
  else
    # No such version - leave version as nil
  end
  @current_resource
end

action :install do
  args = if new_resource.package_url
           # We have a url to install from
           ['install',new_resource.package_url]
         elsif new_resource.version.nil?
           # We have no specific version
           ['install', new_resource.package_name]
         elsif current_resource.version and current_resource.version == new_resource.version
           # We have the current version
           nil
         else
           # We have a specific version
           ['install', "#{new_resource.package_name}==#{new_resource.version}"]
         end
  if args
    converge_by "Installing backslasher_python_pip #{new_resource.package_name}" do
      pip_command(args)
    end
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
  if should_remove? # ~FC023
    converge_by "Removing backslasher_python_pip #{new_resource.package_name}" do
      pip_command(['uninstall','--yes',new_resource.package_name])
    end
  end
end

action :upgrade do
  # Upgrading
  if current_resource.version.nil? or (current_resource.version != new_resource.version) # ~FC023
    converge_by "Upgrading backslasher_python_pip #{new_resource.package_name}" do
      pip_command(['install','--upgrade',new_resource.package_name])
    end
  end
end
