# ICEWATCH


This is the rails application to help data collection for ice observations.   
See the http://icewatch.gina.alaska.edu website for details.

This is distributed as a JRuby application called ASSIST.

## Building distributable ASSIST java app

A vagrant box is provided to build the distributable ASSIST java app for 
Windows, Mac, and Linux.

Start the VM:

```
$ vagrant up
```
Then run these commands which will also be echoed by the `vagrant up` command:
```
1) vagrant ssh
2) gem install bundler
3) cd /assist
4) bundle install
5) export RAILS_ENV=production
6) bundle exec rake assist:package

```

## Developing on the webapp

### Set admins
`rake admin:user` will set logged in users as the admins
