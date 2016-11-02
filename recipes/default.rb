#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

bash 'update-apt' do
  code <<-EOH
    sudo apt-get update -y
    EOH
end


file '/root/.ssh/config' do
  content "Host *
    StrictHostKeyChecking no
  "
  mode "0400"
end

package 'git'
package 'apache2'
package 'php5'
package 'mysql-server'
package 'mysql-client'
package 'php5-mysql'

deploy 'private_repo' do
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  repo 'https://github.com/paradojo/WordPress.git'
  user 'root'
  deploy_to '/var/www'
  action :deploy
end

bash 'update-a' do
  code <<-EOH
    sed -i -- 's/html/current/g' /etc/apache2/sites-available/000-default.conf
    EOH
end

service 'apache2' do
	action :restart
end

template '/var/www/current/wp-config.php' do
  source 'config.php.erb'
  owner 'root'
  group 'root'
  mode '0755'
end