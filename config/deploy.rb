require "bundler/vlad"

set :application, "higgins_catalog"
set :user, 'www'
set :domain, "#{user}@ramses.lostpapyr.us"
set :repository,  "git@github.com:shammond42/higgins-catalog.git"

# set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# set :use_sudo, false
set :deploy_to, "/home/www/#{application}"

# role :web, "ramses.lostpapyr.us"                          # Your HTTP server, Apache/etc
# role :app, "ramses.lostpapyr.us"                          # This may be the same as your `Web` server
# role :db,  "ramses.lostpapyr.us", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :vlad do
  desc "Symlinks the configuration files"
  remote_task :symlink_config, :roles => :web do
    %w(database.yml application.yml).each do |file|
      run "ln -s #{shared_path}/config/#{file} #{current_path}/config/#{file}"
    end
    run "ln -s #{shared_path}/object_photos #{current_path}/public/object_photos"
  end

  desc "Precompile assets"
  remote_task :assets_precompile, :roles => :app do
    run "cd #{current_path} && RAILS_ENV=production rake assets:precompile"
  end

  desc "Notify Airbrake of Deploy"
  remote_task :airbrake_deploy, :roles => :app do
    run "cd #{current_path} && RAILS_ENV=production rake airbrake:deploy TO=#{rails_env}"
  end

  desc "Full deployment cycle: Update, migrate, restart, cleanup"
  remote_task :deploy, :roles => :app do
    Rake::Task['vlad:update'].invoke
    Rake::Task['vlad:bundle:install'].invoke
    Rake::Task['vlad:symlink_config'].invoke
    Rake::Task['vlad:migrate'].invoke
    Rake::Task['vlad:assets_precompile'].invoke
    Rake::Task['vlad:start_app'].invoke
    Rake::Task['vlad:airbrake_deploy'].invoke
    Rake::Task['vlad:cleanup'].invoke
  end
end