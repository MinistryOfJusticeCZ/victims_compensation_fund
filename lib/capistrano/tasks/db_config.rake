namespace :deploy do

  desc "Symlink shared config files"
  task :symlink_config_files do
    on release_roles :all do
      f = 'config/database.yml'
      execute :ln, '-s', shared_path.join(f), shared_path.join(f)
    end
  end

end
