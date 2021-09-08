#Install & enable Apache
execute "apt-get update" do
  command "apt-get update"
end
package "apache2" do
  action :install
end
service "apache2" do
  action [:enable, :start]
end
