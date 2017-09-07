namespace :deploy do

  desc "Symlink shared config files"
  task :symlink_config_files do
      run "ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
  end

end
