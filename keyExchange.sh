#!/bin/bash

set -e
set +x

source ./env.sh

echo "Generating key pairs on master ${MASTER}"   
ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "echo 'y' | ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''";

echo "Copying key from master ${MASTER} locally"
scp -o StrictHostKeyChecking=no ${USER}@${MASTER}:.ssh/id_rsa.pub masterPublicKey

for SLAVE in "${SLAVES[@]}"
do
	echo "Generating key pairs on slave ${SLAVE}"	
	ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "echo 'y' | ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''";

	echo "Copying key from slave ${SLAVE} locally"; 
	scp -o StrictHostKeyChecking=no ${USER}@${SLAVE}:.ssh/id_rsa.pub slavePublicKey; 

	echo "Adding slave [${SLAVE}] to authorized_hosts on master [${MASTER}]"; 
	cat slavePublicKey | ssh -o StrictHostKeyChecking=no root@${MASTER} cat - ">>" .ssh/authorized_keys; 
	ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "chmod 700 ~/.ssh/id_rsa"; 
	
	echo "Adding master [${MASTER}] to authorized_hosts on slave [${SLAVE}]";
	cat masterPublicKey | ssh -o StrictHostKeyChecking=no root@${SLAVE} cat - ">>" .ssh/authorized_keys;
	ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "chmod 700 ~/.ssh/id_rsa";
 	
done

rm slavePublicKey;
rm masterPublicKey;

