Icewatch Web App Installation Steps
------------------------------------

1. Obtain a copy of the database and set it up in postgres. 
   Also, get a copy of the image backups (a tar.gz archive).
2. Set up an instance of the Ogre ogr2ogr webclient to point the app at 
   https://github.com/wavded/ogre
3. Install ImageMagick, and gdal
4. The rest of the paths here are provided relative to the code repo. (i.e. cd to the code repo)
5. Install the "Assist to aspect conversion python tools (a2a)" located in python/ 
   using the setup script (python/setup.py.install). This requires the python packages setuptools, 
   numpy and pandas are installed.
6. Start the rails app ("bundle exec rails start" or something similar). Be sure to set the Ogre url in config/secrets.yml. 
   To restore the image backups untar the images at /tmp/uploads/store/.
   This directory should now contain files named like
   ``7e6904d2d87dd70042bd2ec7fed253f057efa42ca407123ce3ae79b1e7a0``
7. In config/secrets.yml google_key, and google_secret are for Google Analytics 
   intergration.
  

ASSIST App Installation Steps
-----------------------------

1. ASSIST is a version of the web code intended to be run locally.
   This is currently accomplished on windows using Java. This does
   not work very well anymore especially on windows. The directions for 
   building this are in the README.md, but there are issues with jruby. 
2. For better maintainability, I recommend this verison of the 
   app be ported to docker. This would eliminate the need for Java. Here is a tutorial on 
   how that could be done https://docs.docker.com/compose/rails/. 
3. The main setup difference between the ASSIST app and Icewatch web app is the  
   "icewatch_assist" flag.  This flag is set to true in config/secrets.yml for the ASSIST app. 
   Also, the ASSIST app does not need Ogre. 
