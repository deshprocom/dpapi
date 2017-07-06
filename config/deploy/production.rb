server '106.75.136.9',
       user: 'deploy',
       roles: %w{app db cache},
       ssh_options: {
           user: 'deploy',
           keys: %w(~/.ssh/id_rsa),
           forward_agent: false,
           port: 5022,
           auth_methods: %w(publickey password)
       }

role :resque_worker, %w{106.75.136.9}
set :workers, {send_email_sms: 1, send_mobile_sms: 1}

set :deploy_to, '/deploy/production/dpapi'
set :branch, ENV.fetch('REVISION', ENV.fetch('BRANCH', 'production'))
set :rails_env, 'production'
set :bundle_without, %w{tools}.join(' ')

# puma
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_env, fetch(:rails_env, 'production')
set :puma_threads, [0, 16]
set :puma_workers, 5