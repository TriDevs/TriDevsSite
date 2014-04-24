set :stage, :staging
set :rails_env, 'staging'
set :branch, 'staging'

server 'staging.tridevs.com', user: 'rails', roles: %w{web app db},
    ssh_options: {
        port: 22
    }
