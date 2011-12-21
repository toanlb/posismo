# SSH Settings
#set :user, "deploy"

# SCM Settings
set :branch, "production"

# Deploy Settings
set :rails_env, "production"
set :hostname, "hostname"

role :web, "#{hostname}"
role :app, "#{hostname}"
role :db,  "#{hostname}", :primary => true

set :deploy_to, "/srv/#{application}"
