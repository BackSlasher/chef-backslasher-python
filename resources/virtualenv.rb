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
  nr = self # me as new_resource
  directory path do
    user nr.owner if nr.owner
    group nr.group if nr.group
  end
  execute "virtualenv #{"--python="+interpreter if interpreter} #{options} #{path}" do
    user nr.owner if nr.owner
    group nr.group if nr.group
    environment ({ 'HOME' => ::Dir.home(nr.owner) }) if nr.owner

    not_if {nr.exists?}
  end
end

action :delete do
  directory path do
    action :delete
    recursive true
  end
end
