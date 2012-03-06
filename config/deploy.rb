require 'bundler/capistrano'

set :application, "BookBuy"
set :repository,  "git://github.com/subhashb/BookBuy.git"
set :scm, :git
set :scm_username, 'akil_rails'
set :use_sudo, false

task :production do
  set :branch, "production"
  set :default_environment, {  "LD_LIBRARY_PATH" => "/opt/oracle/instantclient_10_2", "TNS_ADMIN" => "/opt/oracle/network/admin" }
  set :user, 'rails'
  set :deploy_to, "/disk1/bookbuy"
  role :web, "74.86.131.195"                          # Your HTTP server, Apache/etc
  role :app, "74.86.131.195"                          # This may be the same as your `Web` server
  role :db,  "74.86.131.195", :primary => true        # This is where Rails migrations will run
end

task :staging do
  set :branch, "staging" 
  set :default_environment, { "PATH" => "/usr/local/ruby-1.9.2-p290/bin:$PATH", "LD_LIBRARY_PATH" => "/opt/oracle/instantclient_10_2", "TNS_ADMIN" => "/opt/oracle/network/admin" }
  set :user, 'ruby'
  set :deploy_to, "/usr/ruby/ams"
  role :web, "jbserver1.interactivedns.com"                          # Your HTTP server, Apache/etc
  role :app, "jbserver1.interactivedns.com"                          # This may be the same as your `Web` server
  role :db,  "jbserver1.interactivedns.com", :primary => true        # This is where Rails migrations will run
end

after "deploy", "deploy:migrate"

namespace :deploy do
  after "deploy:update_code" do
    run "cp #{deploy_to}/database.yml #{release_path}/config/database.yml"
    run "cp #{deploy_to}/settings.yml #{release_path}/config/settings.yml"
    run "cp #{deploy_to}/setup_mail.rb #{release_path}/config/initializers/setup_mail.rb"
    run "cp #{deploy_to}/environment.rb #{release_path}/config/environment.rb"
    run "cp #{deploy_to}/aws-s3.yml #{release_path}/config/aws-s3.yml"
    run "cp #{deploy_to}/sunspot.yml #{release_path}/config/sunspot.yml"
    run "cp #{deploy_to}/newrelic.yml #{release_path}/config/newrelic.yml"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
