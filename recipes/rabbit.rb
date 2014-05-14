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

rabbit_user = secrets['rabbit_user']
rabbit_password = secrets['rabbit_password']
rabbit_virtual_host = secrets['rabbit_virtual_host']

package "rabbitmq-server" do
  action :install
end

script "init_rabbit" do
  interpreter "bash"
  user "root"
  code <<-EOH
	rabbitmqctl add_vhost #{rabbit_virtual_host}
	rabbitmqctl add_user #{rabbit_user} #{rabbit_password}
	rabbitmqctl set_permissions -p #{rabbit_virtual_host} #{rabbit_user} ".*" ".*" ".*"
	rabbitmqctl delete_user guest
	touch /etc/rabbitmq/.init_rabbit_do_not_delete
	EOH
	action :run
  creates "/etc/rabbitmq/.init_rabbit_do_not_delete"
end
