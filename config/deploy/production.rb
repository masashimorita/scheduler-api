server '68.183.170.122', user: 'deploy', port: 22, roles: [:app, :web, :db, :batch], primary: true

set :stage, :production
set :rails_env, 'production'

set :migration_role, 'db'
set :branch, 'production'

