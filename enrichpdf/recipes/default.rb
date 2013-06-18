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
case node['platform_family']
  when "debian"
   include_recipe "apt"
end

include_recipe "tesseract"
include_recipe "graphicsmagick"
include_recipe "nodejs"
include_recipe "xpdf"
include_recipe "daemon"

include_recipe "enrichpdf::install_from_#{node['enrichpdf']['install_method']}"

#workaround
%w{logs procs}.each do |dir|
  directory "#{node['enrichpdf']['dir']}/#{dir}" do
    owner "root"
    group "root"
    mode 00755
    action :create
  end
end



execute "npm install" do
  cwd "#{node['enrichpdf']['dir']}"
  command "npm install"
  creates "#{node['enrichpdf']['dir']}/node_modules"
end

template "/etc/init.d/enrichpdf" do
  source "enrichpdf.erb"
  owner "root"
  group "root"
  mode 00755
end

template "#{node['enrichpdf']['dir']}/config/default.json" do
  source "default.json.erb"
  owner "root"
  group "root"
mode 00644
end

directory "#{node['enrichpdf']['watchpath']}" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

%w{in out}.each do |dir|
  directory "#{node['enrichpdf']['watchpath']}/#{dir}" do
    owner "root"
    group "root"
    mode 00777
    action :create
  end
end

service "enrichpdf" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
  subscribes :reload, "template[#{node['enrichpdf']['dir']}/config/default.json]", :immediately
end
