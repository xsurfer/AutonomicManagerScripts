#!/bin/bash

set +x
set -e

ROOT=$(dirname ${0})

source ${ROOT}/env.sh

echo ""
echo "--- PREPARING ENVIRONMENT ---"

echo "Reset environment..."
rm ${MASTER_ROOT_DIR}/monitor/ -Rf
rm ${MASTER_ROOT_DIR}/RadarGun-1.1.0-SNAPSHOT/ -Rf 
rm ${MASTER_ROOT_DIR}/log/ -Rf

echo "Creating Directories..."
mkdir -p ${MASTER_ROOT_DIR}/log

echo "Copying Monitor..."
cp ${MASTER_ROOT_DIR}/repository/monitor ${MASTER_ROOT_DIR}/. -R
cp ${MASTER_ROOT_DIR}/repository/configs/wpm/config ${MASTER_ROOT_DIR}/monitor/wpm/. -R

echo "Copying Radargun..."
cp ${ROOT}/repository/RadarGun-1.1.0-SNAPSHOT ${MASTER_ROOT_DIR}/. -R
cp ${MASTER_ROOT_DIR}/repository/configs/radargun/conf ${MASTER_ROOT_DIR}/RadarGun-1.1.0-SNAPSHOT/. -R
cp ${MASTER_ROOT_DIR}/repository/configs/radargun/bin ${MASTER_ROOT_DIR}/RadarGun-1.1.0-SNAPSHOT/. -R

echo "Copying Controller..."
cp ${MASTER_ROOT_DIR}/repository/Controller ${MASTER_ROOT_DIR}/. -R

echo "Creating tar file for VMs..."
pushd ${MASTER_ROOT_DIR}/repository
  tar -czf vm.tar.gz monitor/ configs/ RadarGun-1.1.0-SNAPSHOT/
popd


