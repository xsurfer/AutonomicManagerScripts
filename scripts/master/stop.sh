#!/bin/bash

echo ""
echo "--- STOPPING PREVIOUS PROCESSES ---"

RADARGUN_MASTER_PID=`ps -ef | grep "org.radargun.LaunchMaster" | grep -v "grep" | awk '{print $2}'`
LOG_SERVICE_PID=`ps -ef | grep "eu.cloudtm.wpm.main.Main logService" | grep -v "grep" | awk '{print $2}'`
GOSSIP_ROUTER_PID=`ps -ef | grep "org.jgroups.stack.GossipRouter" | grep -v "grep" | awk '{print $2}'`


if [ -z "${RADARGUN_MASTER_PID}" ]
then
  echo "Master not running." 
else
  kill -15 ${RADARGUN_MASTER_PID}
  if [ $? ]
  then 
    echo "Successfully stopped master (pid=${RADARGUN_MASTER_PID})"
  else 
    echo "Problems stopping master(pid=${RADARGUN_MASTER_PID})";
  fi  
fi

if [ -z "${LOG_SERVICE_PID}" ]
then
  echo "LogService not running." 
else
  kill -15 ${LOG_SERVICE_PID}
  if [ $? ]
  then
    echo "Successfully stopped LogService (pid=${LOG_SERVICE_PID})"
  else
    echo "Problems stopping LogService (pid=${LOG_SERVICE_PID})";
  fi
fi

if [ -z "${GOSSIP_ROUTER_PID}" ]
then
  echo "GossipRouter not running." 
else
  kill -15 ${GOSSIP_ROUTER_PID}
  if [ $? ]
  then
    echo "Successfully stopped GossipRouter (pid=${GOSSIP_ROUTER_PID})"
  else
    echo "Problems stopping GossipRouter (pid=${GOSSIP_ROUTER_PID})";
  fi
fi



