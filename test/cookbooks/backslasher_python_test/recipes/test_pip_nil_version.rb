# Author: Nitzan
# Cookbook Name: backslasher_python
# Recipe: test_pip_nil_version
#
# GPLv2

include_recipe 'backslasher-python::pip'

load_resource = Proc.new do |res|
  p = res.provider_for_action(:nothing)
  p.load_current_resource
  p.current_resource
end

backslasher_python_pip 'requests-remove' do
  package_name 'requests'
  action :remove
end

# Assert it's not installed atm
ruby_block 'requests_after' do
  block do
    r=resources(backslasher_python_pip:'requests')
    cr = load_resource[r]
    raise 'Supposed to be missing' unless cr.version.nil?
  end
end

r = backslasher_python_pip "requests"

# Assert it's installed now
ruby_block 'requests_after' do
  block do
    r=resources(backslasher_python_pip:'requests')
    cr = load_resource[r]
    raise 'Supposed to be there' if cr.version.nil?
  end
end
