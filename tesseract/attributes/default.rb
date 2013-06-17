#
# Cookbook Name:: tesseract
# Attributes:: tesseract
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['tesseract']['install_method'] = 'source'
default['tesseract']['version'] = '3.02'
default['tesseract']['version_suffix'] = '02'
default['tesseract']['dir'] = '/usr'
default['tesseract']['src_url'] = "https://tesseract-ocr.googlecode.com/files"
default['tesseract']['make_threads'] = node['cpu'] ? node['cpu']['total'].to_i : 2
