require 'spec_helper.rb'

describe 'icewatch::build-assist' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs java' do
    expect(chef_run).to include_recipe('java::default')
  end

  it 'installs ruby' do
    expect(chef_run).to include_recipe('chruby::system')
  end

  it 'installs zip' do
    expect(chef_run).to install_package('zip')
  end

  it 'installs bundler' do
    expect(chef_run).to install_gem_package('bundler').with(gem_binary: '/opt/rubies/jruby/bin/gem')
  end

  it 'installs gems' do
    expect(chef_run).to run_execute('bundle-install').
      with(cwd: '/www/icewatch', command: 'chruby-exec jruby -- bundle install', env: { 'RAILS_ENV' => 'production' })
  end

  it 'sets up the database' do
    expect(chef_run).to run_execute('chruby-exec jruby -- bundle exec rake db:setup').
      with(cwd: '/www/icewatch', creates: 'db/production.sqlite3', env: { 'RAILS_ENV' => 'production' })
  end

  it 'precompiles the assets' do
    expect(chef_run).to run_execute('chruby-exec jruby -- bundle exec rake assets:precompile').
      with(cwd: '/www/icewatch', env: { 'RAILS_ENV' => 'production' })
  end

  it 'builds the war file' do
    expect(chef_run).to run_execute('warble-executable-war').
      with(cwd: '/www/icewatch', creates: 'assist.war', env: { 'RAILS_ENV' => 'production' })
  end

  it 'creates a distributable zip file' do
    expect(chef_run).to run_execute('create-distributable').
      with(cwd: '/www/icewatch', creates: 'assist-3.0.0.zip')
  end
end
