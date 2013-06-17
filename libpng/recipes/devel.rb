#
# Cookbook Name:: zlib
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "libpng"

case node['platform_family']
when "rhel","fedora"
  package "libpng-devel"
end
