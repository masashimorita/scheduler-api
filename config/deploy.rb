# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "scheduler"
set :repo_url, "git@github.com:MasaCode/scheduler.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, "/var/www/scheduler"
set :user,      "deploy"

set :ssh_options, {
    forward_agent: true,
    user: fetch(:user),
    keys: %w(~/.ssh/deploy)
}

set :puma_threads,    [4, 16]
set :puma_workers,    0
set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

set :log_level, :info

# rbenv settings
set :rbenv_type, :system
set :rbenv_path, '/usr/local/rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]

set :keep_releases, 5

set :linked_dirs, fetch(:linked_dirs, []).push(
    'log',
    'tmp/pids',
    'tmp/cache',
    'tmp/sockets',
    'vendor/bundle',
    'public/system',
    'public/uploads'
)

set :linked_files, fetch(:linked_files, []).push(
    'config/database.yml',
    'config/master.key'
)

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end