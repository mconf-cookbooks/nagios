# Cookbook Name:: nagios
# Recipe:: apache
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

include_recipe "apache2"
include_recipe "apache2::mod_rewrite"

if node['platform'] == 'ubuntu' && Gem::Version.new(node['platform_version']) >= Gem::Version.new('16.04')
  package 'libapache2-mod-php'
else
  include_recipe "apache2::mod_php5"
end

if node['nagios']['enable_ssl']
  include_recipe "apache2::mod_ssl"
end

apache_site "000-default" do
  enable false
end
apache_site "default" do
  enable false
end

public_domain = node['public_domain'] || node['domain']

web_app 'nagios3' do
  template 'apache2.conf.erb'
  variables :public_domain => public_domain,
            :nagios_url => node['nagios']['url']
end
