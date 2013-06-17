#
# Cookbook Name:: zlib
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform_family']
when "rhel","fedora"
  include_recipe "yumrepo::epel"
  package "nodejs"
  package "npm"
end
