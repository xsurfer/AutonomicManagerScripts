#!/bin/bash
##################################################################################
# --> THIS SCRIPT SHOULD BE ON THE VM IMAGE AND IT'S CALLED BY /etc/rc.local <-- #
# This script should be executed by the VM during the bootstrap and it has to    #
# download and extract all the binaries and configuration files.                 #
# VM should be able to contact the gateway through ssh and public key            #
##################################################################################
#

set -x
set -e

RADARGUN_SLAVE_PID=`ps -ef | grep "org.radargun.Slave" | grep -v "grep" | awk '{print $2}'`
WPM_CONSUMER_PID=`ps -ef | grep "eu.cloudtm.wpm.main.Main consumer" | grep -v "grep" | awk '{print $2}'`
WPM_CONTROLLER_PID=`ps -ef | grep "eu.cloudtm.wpm.main.Main producer" | grep -v "grep" | awk '{print $2}'`


#if [ -z "${RADARGUN_SLAVE_PID}" ]
#then
#  echo "Slave not running." 
#else
#  kill -15 ${RADARGUN_SLAVE_PID}
#  if [ $? ]
#  then 
#    echo "Successfully stopped Slave (pid=${RADARGUN_SLAVE_PID})"
#  else 
#    echo "Problems stopping Slave(pid=${RADARGUN_SLAVE_PID})";
#  fi  
#fi

if [ -z "${WPM_CONSUMER_PID}" ]
then
  echo "Consumer not running." 
else
  kill -15 ${WPM_CONSUMER_PID}
  if [ $? ]
  then
    echo "Successfully stopped Consumer (pid=${WPM_CONSUMER_PID})"
  else
    echo "Problems stopping Consumer (pid=${WPM_CONSUMER_PID})";
  fi
fi

if [ -z "${WPM_CONTROLLER_PID}" ]
then
  echo "Controller not running." 
else
  kill -15 ${WPM_CONTROLLER_PID}
  if [ $? ]
  then
    echo "Successfully stopped Controller (pid=${WPM_CONTROLLER_PID})"
  else
    echo "Problems stopping Controller (pid=${WPM_CONTROLLER_PID})";
  fi
fi


echo "Done!"

