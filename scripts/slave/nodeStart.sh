#!/bin/bash
##################################################################################
# --> THIS SCRIPT SHOULD BE ON THE VM IMAGE AND IT'S CALLED BY /etc/rc.local <-- #
# This script should be executed by the VM during the bootstrap and it has to    #
# download and extract all the binaries and configuration files.                 #
# VM should be able to contact the gateway through ssh and public key            #
##################################################################################
#

set +x
set -e

ROOT=$(dirname ${0})

source ${ROOT}/env.sh

REPOSITORY_SSH=${USER}@${MASTER}
REPOSITORY_DIR=${MASTER_ROOT_DIR}/repository/vm.tar.gz

WPM_DIR=${SLAVE_INSTANCE_DIR}/monitor/wpm
WPM_CONF_SOURCE=${SLAVE_INSTANCE_DIR}/configs/wpm/config

RADARGUN_DIR=${SLAVE_INSTANCE_DIR}/RadarGun-1.1.0-SNAPSHOT
RADARGUN_CONF_SOURCE=${SLAVE_INSTANCE_DIR}/configs/radargun/conf
RADARGUN_BIN_SOURCE=${SLAVE_INSTANCE_DIR}/configs/radargun/bin
RADARGUN_PLUGINS_SOURCE=${SLAVE_INSTANCE_DIR}/configs/radargun/plugins

# OTHERS
PRODUCER_HOSTNAME=`hostname`
PRODUCER_IP=`hostname -i`


# CREATING DIRS
rm -rf ${SLAVE_INSTANCE_DIR}
mkdir -p ${SLAVE_INSTANCE_DIR}

mkdir -p ${SLAVE_INSTANCE_DIR}/log

pushd ${SLAVE_INSTANCE_DIR}

  echo "Downloading..."
  scp -o StrictHostKeyChecking=no ${REPOSITORY_SSH}:${REPOSITORY_DIR} ${SLAVE_INSTANCE_DIR}/.

  echo "Extracting..."
  pushd ${SLAVE_INSTANCE_DIR}
    tar xzf vm.tar.gz
    rm -f vm.tar.gz
  popd


  # WPM
  echo "--- Copying config dirs for WPM ---"
  cp -R ${WPM_CONF_SOURCE} ${WPM_DIR}/config

  echo "--- Configuring WPM ---"
  pushd ${WPM_DIR}/config
    sed -i 's/%PRODUCER_HOSTNAME%/'${PRODUCER_HOSTNAME}'/g' resource_controller.config
    sed -i 's/%PRODUCER_IP%/'${PRODUCER_IP}'/g' resource_controller.config
    sed -i 's/%LOG_SERVICE_IP%/'${MASTER}'/g' resource_consumer.config
  popd

  echo "--- Starting Producer && Consumer ---"
  pushd ${WPM_DIR}
    ./run_cons_prod.sh 2>&1 > /dev/null &
  popd


  # RADARGUN
  echo "--- Copying config and bin dirs for RADARGUN ---"
  cp -R ${RADARGUN_BIN_SOURCE} ${RADARGUN_DIR}/bin
  cp -R ${RADARGUN_CONF_SOURCE} ${RADARGUN_DIR}/conf 
  cp -R ${RADARGUN_PLUGINS_SOURCE} ${RADARGUN_DIR}/plugins
  
  pushd ${RADARGUN_DIR}/plugins/infinispan4/conf/jgroups
    echo "* Changing GossipRouter address to ${MASTER}"
    sed -i 's/%GOSSIP_ADDRESS%/'${MASTER}'/g' jgroups-tcp_cloudtm.xml
  popd



  echo "--- Starting Radargun Slave ---" 
  pushd ${RADARGUN_DIR}
    ./bin/slave.sh -m ${MASTER}
  popd

popd

echo "========================"
echo "           DONE         "
echo "========================"

exit 0
