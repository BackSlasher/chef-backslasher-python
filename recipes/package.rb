#
# Cookbook Name:: backslasher-python
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

major_version = node['platform_version'].split('.').first.to_i

# COOK-1016 Handle RHEL/CentOS namings of python packages, by installing EPEL
# repo & package
if platform_family?('rhel') && major_version < 6
  include_recipe 'yum-epel'
  python_pkgs = ["python26", "python26-devel"]
  node.default['python']['binary'] = "/usr/bin/python26"
else
  python_pkgs = value_for_platform_family(
                  "debian"  => ["python","python-dev"],
                  "rhel"    => ["python","python-devel"],
                  "fedora"  => ["python","python-devel"],
                  "freebsd" => ["python"],
                  "smartos" => ["python27"],
                  "default" => ["python","python-dev"]
                )
end

python_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
