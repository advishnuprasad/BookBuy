require 'bundler/capistrano'

set :application, "BookBuy"
set :repository,  "git://github.com/subhashb/BookBuy.git"
set :scm, :git
set :scm_username, 'akil_rails'
set :use_sudo, false

task :production do
  set :branch, "production"
  set :user, 'rails'
  set :deploy_to, "/disk1/bookbuy"
  role :web, "74.86.131.195"                          # Your HTTP server, Apache/etc
  role :app, "74.86.131.195"                          # This may be the same as your `Web` server
  role :db,  "74.86.131.195", :primary => true        # This is where Rails migrations will run
  yield
end

task :staging do
  set :branch, "production"   # Temporary; will be removed when production 
  set :user, 'ruby'
  set :deploy_to, "/usr/ruby/ams"
  role :web, "jbserver1.interactivedns.com"                          # Your HTTP server, Apache/etc
  role :app, "jbserver1.interactivedns.com"                          # This may be the same as your `Web` server
  role :db,  "jbserver1.interactivedns.com", :primary => true        # This is where Rails migrations will run
  yield
end

after "deploy", "deploy:migrate"

namespace :deploy do
  after "deploy:update_code" do
    run "cp #{deploy_to}/database.yml #{release_path}/config/database.yml"
    run "cp #{deploy_to}/setup_mail.rb #{release_path}/config/initializers/setup_mail.rb"
    run "cp #{deploy_to}/environment.rb #{release_path}/config/environment.rb"
    run "cp #{deploy_to}/aws-s3.yml #{release_path}/config/aws-s3.yml"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end