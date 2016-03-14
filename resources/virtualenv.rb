property :path, String, name_attribute: true
property :interpreter, String
attribute :owner, String, regex: Chef::Config[:user_valid_regex]
attribute :group, String, regex: Chef::Config[:group_valid_regex]
attribute :options, String # Additional options for venv initialization

actions :create, :delete
default_action :create

