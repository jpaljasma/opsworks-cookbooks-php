include_recipe 'deploy'

# Run the deploy without restarting the Apache service - you don't need it by default
# Deployment time will also be ~ 50% faster.
# Comment out following lines if you _want_ to restart Apache every time you deploy

#include_recipe "mod_php5_apache2"
#include_recipe "mod_php5_apache2::php"

Chef::Log.debug("Running deploy/recipes/php.rb")

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
end