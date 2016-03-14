attribute :python_path, String, default: 'python'
attribute :package_name, String, name_property: true # Name of the package
attribute :package_url, String, desired_state: false # URL of package location. Optional, used to specify git locations etc
attribute :version, String, default: nil # Package to install. Defaults to "latest"
attribute :virtualenv, String, desired_state: false # Venv
attribute :timeout, Fixnum, deafult: 900, desired_state: false
attribute :user, String, regex: Chef::Config[:user_valid_regex]
attribute :group, String, regex: Chef::Config[:group_valid_regex]
attribute :environment, Hash, desired_state: false
attribute :options, Array, default: [], desired_state: false # Additional options for installation

actions :install, :remove, :upgrade
default_action :install

#TODO treat current_resource
#TODO treat new_resource
