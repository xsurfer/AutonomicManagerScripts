#!/bin/bash

set -e
set +x

ROOT=$(dirname ${0})

source ${ROOT}/env.sh

CUR_DIR=$(pwd)

TMP_DIR=${CUR_DIR}/tmp
rm -rf ${TMP_DIR}
mkdir -p ${TMP_DIR}


# AutonomicManager/
#		monitor
#		Radargun
#		lib
#		config
#		autonomicManager.jar
#		startAM.sh

# Preparing master node

MASTER_DIR=AutonomicManager
TMP_MASTER=${TMP_DIR}/${MASTER_DIR}
mkdir -p ${TMP_MASTER}

echo "This is the MASTER!" > ${TMP_MASTER}/MASTER_README.MD

echo "Copying Repository..."
cp ${CUR_DIR}/repository ${TMP_MASTER}/. -R

echo "Copying node_ips file..."
rm -rf ${TMP_MASTER}/repository/Controller/config/node_ips
cp ${CUR_DIR}/node_ips ${TMP_MASTER}/repository/Controller/config/. -R

echo "Copying Master Scripts && Files..."
mkdir -p ${TMP_MASTER}/scripts
cp ${CUR_DIR}/scripts/master/* ${TMP_MASTER}/scripts/. -R
cp ${CUR_DIR}/env.sh ${TMP_MASTER}/. -R
cp ${CUR_DIR}/node_ips ${TMP_MASTER}/. -R

echo "Creating links..."
ln -s ./scripts/start.sh ${TMP_MASTER}/start.sh
ln -s ./scripts/stop.sh ${TMP_MASTER}/stop.sh
ln -s ./scripts/setup.sh ${TMP_MASTER}/setup.sh

echo "Compressing the dir..."
tar -czf ${TMP_DIR}/AutonomicManager.tar.gz -C ${TMP_DIR} ${MASTER_DIR}

echo "Deleting any previous version..."
ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "rm -rf ${MASTER_INSTALL_DIR}/AutonomicManager.tar.gz"
ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "rm -rf ${MASTER_ROOT_DIR}"

echo "Copying to the master..."
scp -o StrictHostKeyChecking=no ${TMP_DIR}/AutonomicManager.tar.gz ${USER}@${MASTER}:${MASTER_INSTALL_DIR}/.

echo "Extracting remote file..."
ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "tar xzf ${MASTER_INSTALL_DIR}/AutonomicManager.tar.gz -C ${MASTER_INSTALL_DIR}"

echo "Launching the remote setup script..."
ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "bash ${MASTER_ROOT_DIR}/setup.sh"
ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "rm -rf ${MASTER_ROOT_DIR}/setup.sh"

echo "Deleting temp the dir..."
#rm -rf ${TMP_MASTER}
#rm -rf ${TMP_DIR}/AutonomicManager.tar.gz

echo ""
echo ""
echo "Master has been successfully installed. Start it using: ssh ${USER}@${MASTER} \"bash ${MASTER_ROOT_DIR}/start.sh \" "
echo ""
echo ""
