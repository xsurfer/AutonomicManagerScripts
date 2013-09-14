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

ROOT=$(dirname ${0})
source ${ROOT}/env.sh

WPM_DIR=${SLAVE_INSTANCE_DIR}/monitor/wpm

#RADARGUN_SLAVE_PID=`ps -ef | grep "org.radargun.Slave" | grep -v "grep" | awk '{print $2}'`

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


echo "--- Stopping Producer && Consumer ---"
pushd ${WPM_DIR}
  ./run_cons_prod.sh stop
popd


echo "Done!"

