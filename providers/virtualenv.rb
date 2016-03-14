# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

def exists?
  ::File.exist?(new_resource.path) && ::File.directory?(new_resource.path) \
    && ::File.exists?("#{new_resource.path}/bin/activate")
end

action :create do
  nr = new_resource # me as new_resource
  directory new_resource.path do
    user nr.owner if nr.owner
    group nr.group if nr.group
  end
  execute "virtualenv #{"--python="+new_resource.interpreter if new_resource.interpreter} #{new_resource.options} #{new_resource.path}" do
    user nr.owner if nr.owner
    group nr.group if nr.group
    environment ({ 'HOME' => ::Dir.home(nr.owner) }) if nr.owner

    not_if {exists?}
  end
end

action :delete do
  directory new_resource.path do
    action :delete
    recursive true
  end
end
