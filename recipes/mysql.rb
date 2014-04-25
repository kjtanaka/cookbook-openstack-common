#
# Cookbook Name:: openstack-common
# Recipe:: mysql
#
# Copyright 2014, FutureGrid, Indiana University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

secrets = Chef::EncryptedDataBagItem.load("openstack", "secrets")

node.set['mysql']['server_root_password'] = secrets['mysql_admin_password']
node.set['mysql']['server_debian_password'] = secrets['mysql_admin_password']
node.set['mysql']['server_repl_password'] = secrets['mysql_admin_password']
node.set['mysql']['bind-address'] = "0.0.0.0"

include_recipe 'mysql::server'

template '/etc/mysql/conf.d/my_openstack.cnf' do
  owner 'mysql'
  owner 'mysql'      
  source 'my_openstack.cnf.erb'
  notifies :restart, 'mysql_service[default]'
end
