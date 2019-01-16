# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "scheduler"
set :repo_url, "git@github.com:MasaCode/scheduler.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, "/var/www/scheduler"
set :user,      "deploy"
set :pty,             true
set :use_sudo,        false

set :ssh_options, {
    forward_agent: true,
    user: fetch(:user),
    keys: %w(~/.ssh/deploy)
}

set :deploy_via,      :remote_cache
set :log_level, :info
set :keep_releases, 5

# puma settings
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# rbenv settings
set :rbenv_type, :system
set :rbenv_path, '/usr/local/.rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails puma pumactl]

# -------- capistrano-whenever ------- #
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# ------------------------------------ #

set :whenever_roles, :batch
set :whenever_environment, Proc.new { fetch :stage }

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
    'config/master.key',
    '.env'
)

# puma task
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

# deploy task
namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/production`
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      # https://qiita.com/hatorijobs/items/8b57f9a89c3bfb442755
      # execute 'chmod 701 /var/www'
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Update config with deploy'
  task :update_config do
    on roles(:app) do
      before :check,        'setup:config'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'reload the database with seed data'
  task :seed do
    on roles(:db) do
      with rails_env: fetch(:rails_env) do
        within release_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  before :starting,     :check_revision
  # after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :migrate,      :seed
end

namespace :setup do
  desc 'setup config'
  task :config do
    on roles(:app) do |host|
      %w[master.key database.yml].each do |f|
        upload! "config/#{f}", "#{shared_path}/config/#{f}"
      end

      %w[.env].each do |f|
        upload! "#{f}", "#{shared_path}/#{f}"
      end
    end
  end

  desc 'setup nginx'
  task :nginx do
    on roles(:app) do |host|
      %w[scheduler.conf].each do |f|
        upload! "config/#{f}", "#{shared_path}/config/#{f}"
        sudo :cp, "#{shared_path}/config/#{f}", "/etc/nginx/conf.d/#{f}"
        sudo "nginx -s reload"
      end
    end
  end
end