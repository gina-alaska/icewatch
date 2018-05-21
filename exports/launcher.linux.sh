#! /bin/bash
### ASSIST v4.1 laucher
### 
### Use:
### > ./launcher.sh <cruise_name>
###
### If no cruise name is provided 'production is used'
### 
### This tool should be distributed with empty-database.sqlite3. This file
### should not beused to run ASSIST, as it contains the infromation needed to 
### create new cruise databases 

## get cruise name
database=$1

if [ ! ${database} ]
then
    database="production"
fi 

## test for .sqlite3 extension
if [ ${database: -4} != ".sqlite3" ]
then
    database=$database".sqlite3" 
fi

## test for existing cruise
if [ -a ${database} ] 
then
    echo "Cruise database ${database} exists."
    ans=''
    while !([ "$ans" == 'y' ] || [ "$ans" == 'n' ])
    do
        echo "Do you want to use this cruise? [y/n]"
        read ans
    done
    
    if [ "$ans" == 'n' ]
    then
        echo "Exiting. Please try again with the name of the cruies you want to use."
        exit
    fi
    
else    
    echo "Cruise database ${database} does not exist."
    ans=''
    while !([ "$ans" == 'y' ] || [ "$ans" == 'n' ])
    do
        echo "Do you want to use this cruise? [y/n]"
        read ans
    done
    
    if [ "$ans" == 'n' ]
    then
        echo "Exiting. Please try again with the name of the cruies you want to use."
        exit
    else
        echo "Creating Database ${database}"
        cp empty-database.sqlite3 $database
    fi
fi

## Run ASSIST
export SECRET_KEY_BASE='31f071a9f7a37810dbfaa253b07c972be761a1fe90db090fb97382c12f84d8f0d0216ca9feddb430dc95c0e48f79b6a0136c6664e5a07d067dc7305b9b1e4fd3'
export ICEWATCH_ASSIST='true'
java -Ddb=`pwd `/${database} -Dexport=`pwd` -Xms512M -Xmx1G -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -jar ASSIST.war
