@echo off

set DB=%~dp0/production.sqlite3
set EXPORT=%~dp0
set JAR=%~dp0/ASSIST.war
set SECRET_KEY_BASE='31f071a9f7a37810dbfaa253b07c972be761a1fe90db090fb97382c12f84d8f0d0216ca9feddb430dc95c0e48f79b6a0136c6664e5a07d067dc7305b9b1e4fd3'
set ICEWATCH_ASSIST='true'

java -Ddb="%DB%" -Dexport="%EXPORT%" -Xms512M -Xmx1G -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -jar "%JAR%"
