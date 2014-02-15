#!/bin/sh

set -e

ROOT=$(dirname ${0})

# user to use during ssh connections
export USER=ubuntu

# MASTER node will execute RADARGUN MASTER + AUTONOMIC MANAGER + LOG_SERVICE + GOSSIP ROUTER
# slave node will contact master node to download tar.gz file
export MASTER=`grep -v "^#"  < ${ROOT}/node_ips | grep "^MASTER" | cut -d':' -f2`

export MASTER_INSTALL_DIR=/opt
export MASTER_ROOT_DIR=${MASTER_INSTALL_DIR}/AutonomicManager


# each SLAVE node will execute RADARGUN SLAVE + CONSUMER + CONTROLLER

i=0
while read line
do
    SLAVES[ $i ]=$line
    i=$[$i+1]
done < <(grep -v "^#"  < ${ROOT}/node_ips | grep "^SLAVE" | cut -d':' -f2)

# directory where the archive will be extracted
export SLAVE_INSTALL_DIR=/opt
export SLAVE_ROOT_DIR=${SLAVE_INSTALL_DIR}/AutonomicManager
export SLAVE_INSTANCE_DIR=${SLAVE_ROOT_DIR}/instance


echo "Master IP:" ${MASTER}
echo "Number of slaves:" ${#SLAVES[*]}
