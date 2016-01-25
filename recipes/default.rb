#
# Cookbook Name:: backslasher-python
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "backslasher-python::#{node['backslasher-python']['install_method']}"
include_recipe "backslasher-python::pip"
include_recipe "backslasher-python::virtualenv"
