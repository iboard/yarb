namespace "deploy" do

  desc "Deploy Yard-doc to iboard.cc (needs authentication with ssh-keys)"
  task :docs do
    system "yard"
    system "rsync", "-avze", "ssh", "doc", "www-data@dav.iboard.cc:/var/www/dav/container/yarb/"
  end

  desc "Deploy to live-demo (needs authentication with ssh-keys)"
  task :app do
    system "ssh deployer@edge.iboard.cc bash --login apps/yarb/bin/update_and_restart.sh"
  end

end
