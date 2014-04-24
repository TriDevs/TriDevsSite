lock '3.2.1'

set :application, 'TriDevsSite'
set :repo_url, 'git@github.com:TriDevs/TriDevsSite.git'
set :deploy_to, "/home/#{fetch(:user, 'rails')}/apps/#{fetch(:application)}"
set :log_level, :debug
set :linked_files, %w{config/database.yml config/secrets.yml}
set :ssh_options, { forward_agent: true }

namespace :deploy do
  desc "Setup the basic app structure"
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/{config,log,pids}"
      upload! "config/database.example.yml", "#{shared_path}/config/database.yml"
      upload! "config/secrets.example.yml", "#{shared_path}/config/secrets.yml"
      puts "Now edit the config files in #{shared_path}."
      puts "Execute the following commands:"
      puts "sudo ln -nfs #{current_path}/config/nginx_#{fetch(:rails_env)}.conf /etc/nginx/sites-enabled/#{fetch(:application)}_#{fetch(:rails_env)}"
      puts "sudo ln -nfs #{current_path}/config/unicorn_init_#{fetch(:rails_env)}.sh /etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:rails_env)}"
      puts "sudo update-rc.d -f unicorn_#{fetch(:application)}_#{fetch(:rails_env)} defaults"
    end
  end

  %w{start stop restart}.each do |command|
    desc "#{command} application"
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        execute "/etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)}", command
      end
    end
  end

  after :publishing, :restart
end
