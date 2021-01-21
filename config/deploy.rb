require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '172.21.35.163'
set :deploy_to, '/app'
set :repository, 'git@github.com:pluosi/app-host.git'
set :branch, 'master'

# Optional settings:
set :user, 'vagrant'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'public/sitemaps', 'public/uploads', 'tmp')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'config/settings.local.yml' )

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  ruby_version = File.read('.ruby-version').strip
  raise "Couldn't determine Ruby version: Do you have a file .ruby-version in your project root?" if ruby_version.empty?
  command %{
    source "$HOME/.rvm/scripts/rvm"
    rvm use #{ruby_version} || exit 1
  }
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup => :remote_environment do
  command %{gem install bundler}
    # command %{sudo gem install god}
    # command %{sudo mkdir -p /etc/god/conf.d/}

  %w{log tmp/pids tmp/sockets config public/uploads public/sitemaps}.each do |dir|
    command %{mkdir -p "#{fetch(:shared_path)}/#{dir}"}
    command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/#{dir}"}
  end
end

desc "Deploys the current version to the server."
task :deploy => :remote_environment do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
      invoke :'puma:restart'
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run :local { say 'done' }
end


namespace :puma do

  desc 'start puma'
  task :start => :remote_environment do
    in_path(fetch(:current_path)) do
      command %{bundle exec 'puma --config ./config/puma.rb -e production &'}
    end
  end

  desc 'stop puma'
  task :stop => :remote_environment do
    in_path(fetch(:current_path)) do
      command %{bundle exec pumactl stop}
    end
  end

  desc 'restart puma'
  task :restart => :remote_environment do
    command %{bundle exec pumactl stop || true}
    invoke :'puma:start'
  end

end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
