set :stage, :production
set :rails_env, 'production'
set :branch, 'production'

server 'tridevs.com', user: 'rails', roles: %w{web app db},
    ssh_options: {
        port: 22
    }
