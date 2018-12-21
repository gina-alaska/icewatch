# General ICEWATCH Information


Icewatch is the rails application to help with data collection for ice observations.   
See the http://icewatch.gina.alaska.edu website for details.

This is distributed as a JRuby application called ASSIST.

## installing the python module for assist 2 aspcet conversions

cd to the python directory and run

`<path_to_systempython>/python2.7 setup.py install` or `develop`
if you wish to modify the python code

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

see README-deploy-icewatch.rst
### Set admins
`rake admin:user` will set logged in users as the admins


## Manual bundle of assist launcher zip archive
`cd exports`
`zip -r ASSIST_v4.1.zip *`
`cd ../public`
`rm ASSIST_v4.1.zip`
`mv ../exports/ASSIST_v4.1.zip ./`
