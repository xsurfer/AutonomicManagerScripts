#!/bin/bash

set -e
set +x

source ./env.sh

for SLAVE in "${SLAVES[@]}"
do

	echo Copying key from machine ${SLAVE} locally
	scp -o StrictHostKeyChecking=no root@${SLAVE}:.ssh/id_rsa.pub keyToCopy

#	echo "Copying from master (${MASTER}) to slave (${SLAVE})"
#	ssh -o StrictHostKeyChecking=no root@${MASTER} "ssh-copy-id -o StrictHostKeyChecking=no root@${SLAVE}"	

#	echo "Copying from slave (${SLAVE}) to master (${MASTER})"
#	ssh -o StrictHostKeyChecking=no root@${SLAVE} "ssh-copy-id -o StrictHostKeyChecking=no root@${MASTER}"

	echo Adding ${SLAVE} to authorized_hosts on ${MASTER}
	cat keyToCopy | ssh -o StrictHostKeyChecking=no root@${MASTER} cat - ">>" .ssh/authorized_keys

	
done
