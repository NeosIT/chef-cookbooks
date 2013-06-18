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
include_recipe "leptonica"


tesseract_tar = "tesseract-ocr-#{node['tesseract']['version']}.#{node['tesseract']['version_suffix']}.tar.gz"
tesseract_eng_tar = "tesseract-ocr-#{node['tesseract']['version']}.eng.tar.gz"
tesseract_deu_tar = "tesseract-ocr-#{node['tesseract']['version']}.deu.tar.gz"
tesseract_src_url = "#{node['tesseract']['src_url']}/#{tesseract_tar}"
tesseract_eng_src_url = "#{node['tesseract']['src_url']}/#{tesseract_eng_tar}"
tesseract_deu_src_url = "#{node['tesseract']['src_url']}/#{tesseract_deu_tar}"


directory "/usr/local/src" do
  owner "root"
  group "root"
  mode 00644
  action :create
end

remote_file "/usr/local/src/#{tesseract_eng_tar}" do
  source tesseract_eng_src_url
  mode 0644
  action :create_if_missing
end

remote_file "/usr/local/src/#{tesseract_deu_tar}" do
  source tesseract_deu_src_url
  mode 0644
  action :create_if_missing
end

remote_file "/usr/local/src/#{tesseract_tar}" do
  source tesseract_src_url
  mode 0755
  action :create_if_missing
end


# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{tesseract_tar}" do
  cwd "/usr/local/src"
  creates "/usr/local/src/tesseract-ocr"
end

bash "compile tesseract (on #{node['tesseract']['make_threads']} cpu)" do
#  # OSX doesn't have the attribute so arbitrarily default 2
  cwd "/usr/local/src/tesseract-ocr"
  code <<-EOH
    ./configure --prefix=#{node['tesseract']['dir']} && \
    make -j #{node['tesseract']['make_threads']}
  EOH
  creates "/usr/local/src/tesseract-ocr/api/.libs/tesseract"
end

execute "tesseract make install" do
  command "make install && /sbin/ldconfig"
  cwd "/usr/local/src/tesseract-ocr"
  creates "#{node['tesseract']['dir']}/bin/tesseract"
end

execute "tar --no-same-owner -zxf #{tesseract_eng_tar} --strip 1 -C #{node['tesseract']['dir']}/share" do
  cwd "/usr/local/src"
  creates "#{node['tesseract']['dir']}/share/tessdata/eng.traineddata"
end

execute "tar --no-same-owner -zxf #{tesseract_deu_tar} --strip 1 -C #{node['tesseract']['dir']}/share" do
  cwd "/usr/local/src"
  creates "#{node['tesseract']['dir']}/share/tessdata/deu.traineddata"
end
