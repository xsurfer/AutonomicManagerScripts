#!/bin/bash

set -e
set -x

ROOT=$(dirname ${0})

source ${ROOT}/env.sh

CUR_DIR=$(pwd)

TMP_DIR=${CUR_DIR}/slave_tmp
rm -rf ${TMP_DIR}
mkdir -p ${TMP_DIR}


# ~/AutonomicManager/
#		scripts/
#			env.sh
#			nodeStart.sh
#			nodeStop.sh
#		link-nodeStart.sh
#		link-nodeStop.sh
#		instance/
#			Radargun
#			monitor


# Preparing master node

SLAVE_DIR=AutonomicManager
TMP_SLAVE=${TMP_DIR}/${SLAVE_DIR}
mkdir -p ${TMP_SLAVE}

echo "This is a SLAVE!" > ${TMP_SLAVE}/SLAVE_README.MD

echo "Copying Slave Scripts && Files..."
mkdir -p ${TMP_SLAVE}/scripts
cp ${CUR_DIR}/scripts/slave/* ${TMP_SLAVE}/scripts/. -R
cp ${CUR_DIR}/env.sh ${TMP_SLAVE}/. -R
cp ${CUR_DIR}/node_ips ${TMP_SLAVE}/. -R


echo "Creating links..."
ln -s ./scripts/nodeStart.sh ${TMP_SLAVE}/nodeStart.sh
ln -s ./scripts/nodeStop.sh ${TMP_SLAVE}/nodeStop.sh

echo "Compressing the dir..."
tar -czf ${TMP_DIR}/AutonomicManager.tar.gz -C ${TMP_DIR} ${SLAVE_DIR}


for SLAVE in "${SLAVES[@]}"
do
  
  #echo "Deleting eventually previous version in ${USER}@${SLAVE}..."
  #ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "rm -rf ${SLAVE_INSTALL_DIR}/${SLAVE_DIR}"


  #echo "Copying to slave ${USER}@${SLAVE}..."
  #scp -o StrictHostKeyChecking=no ${TMP_DIR}/AutonomicManager.tar.gz ${USER}@${SLAVE}:${SLAVE_INSTALL_DIR}/.

  #echo "Extracting remote file..."
  #ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "tar xzf ${SLAVE_INSTALL_DIR}/AutonomicManager.tar.gz -C ${SLAVE_INSTALL_DIR}"

( \
	ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "rm -rf ${SLAVE_INSTALL_DIR}/${SLAVE_DIR}"; \
	scp -o StrictHostKeyChecking=no ${TMP_DIR}/AutonomicManager.tar.gz ${USER}@${SLAVE}:${SLAVE_INSTALL_DIR}/. ; \
	ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "tar xzf ${SLAVE_INSTALL_DIR}/AutonomicManager.tar.gz -C ${SLAVE_INSTALL_DIR}" \
) &
 
	
done


echo "Deleting temp the dir..."
#rm -rf ${TMP_SLAVE}
#rm -rf ${TMP_DIR}/AutonomicManager.tar.gz

echo ""
echo ""
echo "Slaves have been successfully installed. Start them using: ssh ${USER}@<slave_ip> \"bash ${SLAVE_INSTALL_DIR}/${SLAVE_DIR}/nodeStart.sh \" "
echo ""
echo ""
