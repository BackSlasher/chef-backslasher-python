property :path, kind_of: String, name_attribute: true
property :interpreter, kind_of: String
attribute :owner, kind_of: String, regex: Chef::Config[:user_valid_regex]
attribute :group, kind_of: String, regex: Chef::Config[:group_valid_regex]
attribute :options, kind_of: String # Additional options for venv initialization

actions :create, :delete
default_action :create

