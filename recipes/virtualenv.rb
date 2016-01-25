include_recipe 'backslasher-python::pip'

backslasher_python_pip 'virtualenv' do
  action :upgrade
end
