# SSH Settings
#set :user, "deploy"

# SCM Settings
set :branch, "staging"

# Deploy Settings
set :rails_env, "staging"
set :hostname, "hostname"

role :web, "#{hostname}"
role :app, "#{hostname}"
role :db,  "#{hostname}", :primary => true

set :deploy_to, "/srv/#{application}"
