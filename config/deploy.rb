#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'
#require 'capistrano/deepmodules'

set :application, "thk"
set :deploy_to, "/var/home/hosting_abbb/projects/thk"
set :deploy_via, :remote_cache
set :use_sudo, true
set :user, "hosting_abbb"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_string, "1.9.2"
set :rvm_type, :user

set :scm, "git"
set :repository,  "git@github.com:ramusus/thk.git"
set :branch, "master"

role :web, "neon.locum.ru"                          # Your HTTP server, Apache/etc
role :app, "neon.locum.ru"                          # This may be the same as your `Web` server
role :db,  "neon.locum.ru", :primary => true # This is where Rails migrations will run

set :css_files, [
  'all.css',
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

namespace :deploy do
  task :start do
    run "bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
   end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
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