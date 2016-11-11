# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-6.8"

  # config.vm.box_check_update = false

  config.vm.synced_folder ".", "/assist"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.vm.provision "shell", inline: <<-SHELL
    # PACKAGE DEPS
    yum install -y java-1.8.0-openjdk-headless java-1.8.0-openjdk-devel zip git

    # CHRUBY
    if [[ ! -f /usr/local/bin/chruby-exec ]]; then
      wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
      tar -xzvf chruby-0.3.9.tar.gz
      cd chruby-0.3.9/
      sudo make install
    fi

    # RUBY-INSTALL
    if [[ ! -f /usr/local/bin/ruby-install ]]; then
      wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
      tar -xzvf ruby-install-0.6.0.tar.gz
      cd ruby-install-0.6.0/
      sudo make install
    fi

    # JRUBY
    /usr/local/bin/ruby-install jruby 9.1.5.0

    # NODE and BOWER
    if [[ ! -f /usr/loca/bin/npm ]]; then
      curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
      yum -y install nodejs
      npm install -g bower
    fi

    # Configure login shells
    grep "^source /usr/local/share/chruby/chruby.sh" /home/vagrant/.bashrc || \
      echo "source /usr/local/share/chruby/chruby.sh" >> /home/vagrant/.bashrc && \
      echo "chruby jruby" >> /home/vagrant/.bashrc

    echo "FORCING GEMFILE.LOCK to JRUBY"
    ln -sf /assist/Gemfile.lock.java /assist/Gemfile.lock

    echo "Done as much as I can for now.  To proceed: "
    echo "  1) vagrant ssh"
    echo "  2) gem install bundler"
    echo "  3) cd /assist"
    echo "  4) bundle install"
    echo "  5) export RAILS_ENV=production"
    echo "  6) bundle exec rake assist:package"

  SHELL
end
