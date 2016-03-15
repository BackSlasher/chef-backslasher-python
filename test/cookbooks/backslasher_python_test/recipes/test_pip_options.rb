directory '/tmp/test_pip_options' do
  action :delete
  recursive true
end

backslasher_python_virtualenv "/tmp/test_pip_options"

directory "/tmp/test_pip_options/bla"

backslasher_python_pip 'should_dsl with options' do
  package_name 'should_dsl'
  version '2.1.1'
  virtualenv "/tmp/test_pip_options"
  install_options ['-t','/tmp/test_pip_options/bla']
end

# Fail if you can't find a directory, meaning the package did not install
ruby_block 'fail test_pip_options' do
  block do
    raise 'Options resource parameter did not apply'
  end
  not_if 'test -d /tmp/test_pip_options/bla/should_dsl-2.1.1*'
end

backslasher_python_pip 'should_dsl upgrade with options' do
  package_name 'should_dsl'
  action :upgrade
  version '2.1.2'
  virtualenv "/tmp/test_pip_options"
  install_options ['-t','/tmp/test_pip_options/bla']
end

# Fail if you can't find a directory, meaning the package did not install
ruby_block 'fail test_pip_options upgrade' do
  block do
    raise 'Options resource parameter did not apply or upgrade did not work'
  end
  not_if 'test -d /tmp/test_pip_options/bla/should_dsl-2.1.2*'
end
