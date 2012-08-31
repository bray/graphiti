require 'bundler/capistrano'

set :application, "graphiti"
set :deploy_to, "/var/www/graphiti"
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:bray/graphiti.git"
set :user, "deploy"
set :use_sudo, false
set :normalize_asset_timestamps, false

set :unicorn_binary, "unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E production -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{unicorn_pid} ]; then kill `cat #{unicorn_pid}`; fi"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

task :production do
  server 'graphiti.pp.local', :web, :app, :db, :primary => true
end

namespace :graphiti do
  task :link_configs do
    run "cd #{release_path} && ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
    run "cd #{release_path} && ln -nfs #{shared_path}/config/amazon_s3.yml #{release_path}/config/amazon_s3.yml"
    run "cd #{release_path} && ln -nfs #{shared_path}/config/auth.yml #{release_path}/config/auth.yml"
  end

  task :compress do
    run "cd #{release_path} && bundle exec jim compress"
  end
end

after "deploy:update_code", "graphiti:link_configs"
after "deploy:update_code", "graphiti:compress"
