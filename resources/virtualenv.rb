property :path, String, name_attribute: true
property :intepreter, String
property :owner, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
property :options, String # Additional options for venv initialization

def exists?
  ::File.exist?(current_resource.path) && ::File.directory?(current_resource.path) \
    && ::File.exists?("#{current_resource.path}/bin/activate")
end

action :create do
  directory new_resource.path do
    user new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
  end
  execute "virtualenv #{"--python="+new_resource.intepreter if new_resource.intepreter} #{new_resource.options} #{new_resource.path}" do
    user new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
    environment ({ 'HOME' => ::Dir.home(new_resource.owner) }) if new_resource.owner

    only_if {exists?}
  end
end

action :delete do
  directory new_resource.path do
    action :delete
    recursive true
  end
end
