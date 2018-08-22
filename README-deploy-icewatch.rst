Icewatch Web
------------

1. Obtain a copy of the database and set it up in postgres. 
   Also, get a copy of the image backups (a tar.gz archive).
2. Set up an instance of the Ogre ogr2ogr webclient to point the app at 
   https://github.com/wavded/ogre
3. Install ImageMagick, and gdal
4. The rest of the paths here are provided relative to the code repo.
5. Install the Assist to aspect conversion python tools located in python/ 
   using the setup script. This requires that the python packages setuptools, 
   numpy, and pandas are installed.
6. Deploy the rails app. Be sure to set the Ogre url in config/secrets.yml. 
   To restore the image backups untar the images at /tmp/uploads/store/.
   This directory should now contain files named like
   ``7e6904d2d87dd70042bd2ec7fed253f057efa42ca407123ce3ae79b1e7a0``
7. In config/secrets.yml google_key, and google_secret are for Google Analytics 
   intergration

ASSIST
------

1. ASSIST is version of the web code indended to be run locally.
   This is crrently accompilished on windows using Java. This does
   not work evry well anymore especially on windows. The directions for 
   building this are in the readme, but there are issues with jruby. 
2. For better maintainability, I reccomend that this verison of the 
   app be ported to docker. This would eliminate Java. Here is a tutorial on 
   how that could be done https://docs.docker.com/compose/rails/. 
3. The main difference setup wise between the this and the web app is that 
   icewatch_assist is set to true in config/secrets.yml. Also this version
   does not need Ogre to work. 
