attribute :python_path, kind_of: String, default: 'python'
attribute :package_name, kind_of: String, name_attribute: true # Name of the package
attribute :package_url, kind_of: String # URL of package location. Optional, used to specify git locations etc
attribute :version, kind_of: String, default: nil # Package to install. Defaults to "latest"
attribute :virtualenv, kind_of: String # Venv
attribute :timeout, kind_of: Fixnum, default: 900
attribute :user, kind_of: String, regex: Chef::Config[:user_valid_regex]
attribute :group, kind_of: String, regex: Chef::Config[:group_valid_regex]
attribute :environment, kind_of: Hash
attribute :options, kind_of: Array, default: [] # Additional options for installation

actions :install, :remove, :upgrade
default_action :install
