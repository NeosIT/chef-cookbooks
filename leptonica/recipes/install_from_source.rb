#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"
include_recipe "giflib::devel"
include_recipe "libjpeg::devel"
include_recipe "libpng::devel"
include_recipe "libtiff::devel"
include_recipe "zlib::devel"


leptonica_tar = "leptonica-#{node['leptonica']['version']}.tar.gz"
leptonica_src_url = "#{node['leptonica']['src_url']}/#{leptonica_tar}"


directory "/usr/local/src" do
  owner "root"
  group "root"
  mode 00755
  action :create
end


remote_file "/usr/local/src/#{leptonica_tar}" do
  source leptonica_src_url
  mode 0644
  action :create_if_missing
end

# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{leptonica_tar}" do
  cwd "/usr/local/src"
  creates "/usr/local/src/leptonica-#{node['leptonica']['version']}"
end

bash "compile leptonica (on #{node['leptonica']['make_threads']} cpu)" do
  # OSX doesn't have the attribute so arbitrarily default 2
  cwd "/usr/local/src/leptonica-#{node['leptonica']['version']}"
  code <<-EOH
    ./configure --prefix=#{node['leptonica']['dir']} && \
    make -j #{node['leptonica']['make_threads']}
  EOH
  creates "/usr/local/src/leptonica-#{node['leptonica']['version']}/src/.libs/liblept.so"
end

execute "leptonica make install" do
  command "make install && /sbin/ldconfig"
  cwd "/usr/local/src/leptonica-#{node['leptonica']['version']}"
  creates "#{node['leptonica']['dir']}/lib/liblept.so"
end
