#
# Cookbook Name:: backslasher-python
# Recipe:: default
#
# GPLv2
#
#

include_recipe "backslasher-python::#{node['backslasher-python']['install_method']}"
include_recipe "backslasher-python::pip"
include_recipe "backslasher-python::virtualenv"
