namespace :deploy do

  desc "Symlink shared config files"
  task :symlink_config_files do
    on release_roles :all do
      ['config/database.yml', 'config/config.yml', 'config/unicorn.rb'].each do |f|
        execute :ln, '-s', shared_path.join(f), release_path.join(f)
      end
    end
  end

end
