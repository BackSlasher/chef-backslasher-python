# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :install do
  get_pip = "#{Chef::Config[:file_cache_path]}/get-pip.py"
  remote_file get_pip do
    source 'https://bootstrap.pypa.io/get-pip.py'
  end

  execute 'install-pip' do
    not_if "#{new_resource.python_path} -m pip.__main__ 2>&1 >/dev/null"
    command "#{new_resource.python_path} #{get_pip}"
  end
end
