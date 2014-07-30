#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#require 'rvm/capistrano'
require 'bundler/capistrano'
#require 'capistrano/deepmodules'

ssh_options[:forward_agent] = true
default_run_options[:shell] = '/bin/bash --login'

set :application,     "tver-hockey-club"
set :deploy_server,   "boron.locum.ru"

set :bundle_without,  [:development, :test]

set :user,            "hosting_abbb"
set :login,           "abbb"
set :use_sudo,        false
set :deploy_to,       "/home/#{user}/projects/#{application}"
set :unicorn_conf,    "/etc/unicorn/#{application}.#{login}.rb"
set :unicorn_pid,     "/var/run/unicorn/#{user}/#{application}.#{login}.pid"
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')
role :web,            deploy_server
role :app,            deploy_server
role :db,             deploy_server, :primary => true

# Следующие строки необходимы, т.к. ваш проект использует rvm.
set :rvm_ruby_string, "1.9.2"
set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

set :scm, "git"
set :repository,  "git@github.com:ramusus/thk.git"
set :branch, "master"

set :css_files, [
  'normalize.css',
  'screen.css',
]
set :js_files, [
  'vendor/modernizr-2.6.2.min.js',
  'vendor/jquery-1.8.2.min.js',
  'main.js',
]
set :css_source_dir, '../project_html/build/stylesheets/'
set :js_source_dir, '../project_html/build/javascripts/'
set :img_source_dir, '../project_html/build/images/'

default_run_options[:pty] = true

after "bundle:install", "deploy:auto_migrate"

## Чтобы не хранить database.yml в системе контроля версий, поместите
## dayabase.yml в shared-каталог проекта на сервере и раскомментируйте
## следующие строки.
before "deploy:auto_migrate", :copy_database_config
task :copy_database_config, roles => :app do
 db_config = "#{shared_path}/database.yml"
 run "cp #{db_config} #{release_path}/config/database.yml"
end

before 'deploy:finalize_update', 'set_current_release'
task :set_current_release, :roles => :app do
    set :current_release, latest_release
end

set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use #{rvm_ruby_string} do bundle exec unicorn_rails -Dc #{unicorn_conf})"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
  task :auto_migrate do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:auto:migrate"
  end
end

#namespace :data do
#  task :load do
#    rake = fetch(:rake, "rake")
#    rails_env = fetch(:rails_env, "production")
##    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:data:load"
#    top.upload "public/images", "#{deploy_to}/shared/system/old_images", :recursive => true
#  end
#end
namespace :static do
  task :copy do
    css_files.each do |file|
      system "cp #{css_source_dir}#{file} app/assets/stylesheets/"
    end
    js_files.each do |file|
      system "cp #{js_source_dir}#{file} app/assets/javascripts/"
    end
    system "cp -R #{img_source_dir} public"
  end
end

# from here https://gist.github.com/2016396
namespace :deploy do
  desc "Push local changes to Git repository"
  task :push do
    # Check for any local changes that haven't been committed
    # Use 'cap deploy:push IGNORE_DEPLOY_RB=1' to ignore changes to this file (for testing)
#    status = %x(git status --porcelain).chomp
#    if status != ""
#      if status !~ %r{^[M ][M ] config/deploy.rb$}
#        raise Capistrano::Error, "Local git repository has uncommitted changes"
#      elsif !ENV["IGNORE_DEPLOY_RB"]
#        # This is used for testing changes to this script without committing them first
#        raise Capistrano::Error, "Local git repository has uncommitted changes (set IGNORE_DEPLOY_RB=1 to ignore changes to deploy.rb)"
#      end
#    end

    # Check we are on the master branch, so we can't forget to merge before deploying
    branch = %x(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/').chomp
    if branch != "master" && !ENV["IGNORE_BRANCH"]
      raise Capistrano::Error, "Not on master branch (set IGNORE_BRANCH=1 to ignore)"
    end

    # Push the changes
    if ! system "git push #{fetch(:repository)} master"
      raise Capistrano::Error, "Failed to push changes to #{fetch(:repository)}"
    end

  end
end

if !ENV["NO_PUSH"]
  before "deploy", "deploy:push"
  before "deploy:migrations", "deploy:push"
end