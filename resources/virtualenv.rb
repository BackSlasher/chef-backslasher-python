property :path, String, name_attribute: true
property :interpreter, String
property :owner, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
property :options, String # Additional options for venv initialization

default_action :create

def exists?
  ::File.exist?(path) && ::File.directory?(path) \
    && ::File.exists?("#{path}/bin/activate")
end

action :create do
  directory path do
    user owner if owner
    group group if group
  end
  execute "virtualenv #{"--python="+interpreter if interpreter} #{options} #{path}" do
    user owner if owner
    group group if group
    environment ({ 'HOME' => ::Dir.home(owner) }) if owner

    not_if {exists?}
  end
end

action :delete do
  directory path do
    action :delete
    recursive true
  end
end
