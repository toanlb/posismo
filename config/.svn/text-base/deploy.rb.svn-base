default_run_options[:pty] = true
require "bundler/capistrano"

set :application, "2pm"

# Multistage Deploy Settings
set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# SSH Settings
set :use_sudo, false
ssh_options[ :forward_agent ] = true
ssh_options[:verbose] = :warn

# SCM Settings
set :scm, :git
#set :scm_user, "deploy"
#set :repository,  "#{scm_user}@localhost:/srv/git/2pm.git"
set :repository,  "localhost:/srv/git/2pm.git"
#set :git_enable_submodules, true
set :scm_verbose, true
set :git_shallow_clone, 1
set :keep_releases, 30

# Deploy Settings
#set :deploy_via, :remote_cache
#set :deploy_via, :copy
set :rails_env, :staging

# Task chains
after "deploy:symlink", "deploy:symlink_banner_images"
after "deploy:setup", "deploy:create_banner_images_dir"

# Tasks
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Populate seeds in DB"
  task :seed, :roles => :app, :except => { :no_release => true } do 
    puts "\n\n=== Populating the Production Database! ===\n\n"
    run "cd #{current_path};RAILS_ENV=#{rails_env} bundle exec rake db:seed "
  end

  desc "Update symbolic link"
  task :symlink_banner_images, :roles => :app, :except => { :no_release => true } do
    puts "Updating symbolic link"
    run "#{try_sudo} ln -s -n -f #{shared_path}/uploads/bannerimages #{current_path}/public/bannerimages"
  end

  desc "Create directory for uploaded files."
  task :create_banner_images_dir, :roles => :app do
    puts "Create banner images dir..."
    run "#{try_sudo} mkdir -p #{shared_path}/uploads/bannerimages"
  end

end
