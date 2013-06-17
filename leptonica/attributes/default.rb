#
# Cookbook Name:: leptonica
# Attributes:: leptonica
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['leptonica']['install_method'] = 'source'
default['leptonica']['version'] = '1.69'
default['leptonica']['dir'] = '/usr'
default['leptonica']['src_url'] = "http://leptonica.org/source"
default['leptonica']['make_threads'] = node['cpu'] ? node['cpu']['total'].to_i : 2
