server '138.68.251.204', port: 22, roles: [:app, :web, :db], primary: true

set :stage, :production
set :rails_env, 'production'

set :migration_role, 'db'
set :branch, 'production'

