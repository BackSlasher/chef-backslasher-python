directory '/tmp/test_pip_smart_install' do
  action :delete
  recursive true
end

backslasher_python_virtualenv "/tmp/test_pip_smart_install"

backslasher_python_pip 'should_dsl smart_install first' do
  package_name 'should_dsl'
  version '2.1.1'
  virtualenv "/tmp/test_pip_smart_install"
  smart_install true
end

ruby_block 'fail test_pip_smart_install first' do
  block do
    raise 'Smart install didnt install first instance'
  end
  not_if '/tmp/test_pip_smart_install/bin/pip list | grep should-dsl'
end

ruby_block 'fail test_pip_smart_install second' do
  action :nothing
  block do
    raise 'Smart install didnt stop second instance'
  end
end

# Should not run
backslasher_python_pip 'should_dsl smart_install second' do
  package_name 'should-dsl<=2.1.1'
  virtualenv "/tmp/test_pip_smart_install"
  smart_install true
  notifies :run, 'ruby_block[fail test_pip_smart_install second]', :immediate
end
