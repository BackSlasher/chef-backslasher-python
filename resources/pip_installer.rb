property :python_path, String, default: 'python'

action :install do
  get_pip = "#{Chef::Config[:file_cache_path]}/get-pip.py"
  remote_file get_pip do
    source 'https://bootstrap.pypa.io/get-pip.py'
  end

  execute 'install-pip' do
    not_if "#{python_path} -m pip.__main__ &>/dev/null"
    command "#{python_path} #{get_pip}"
  end
end
