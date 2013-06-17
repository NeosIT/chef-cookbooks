#
# Cookbook Name:: enrichpdf
# Attributes:: enrichpdf
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['enrichpdf']['install_method'] = 'git'
default['enrichpdf']['version'] = '0.1'
default['enrichpdf']['dir'] = '/opt/EnrichPDF'
default['enrichpdf']['src_url'] = "http://foo.bar"
default['enrichpdf']['git_url'] = "git://github.com/NeosIT/enrichpdf.git"
default['enrichpdf']['make_threads'] = node['cpu'] ? node['cpu']['total'].to_i : 2
