#!/bin/bash

set -e
set +x

source ./env.sh

remote_key_exists() {
  USER=$1
  HOST=$2
  if ssh ${USER}@${HOST} stat ~/.ssh/id_rsa.pub \> /dev/null 2\>\&1
  then
    echo "Key does not exist! Creatin a new one"
    return 1
  fi
  return 0
}

create_remote_key() {
  USER=$1
  HOST=$2
  ssh ${USER}@${HOST} "ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''"
}
 

echo "Copying key from master ${MASTER} locally"
if remote_key_exists ${USER} ${MASTER}
then
  scp -o StrictHostKeyChecking=no ${USER}@${MASTER}:.ssh/id_rsa.pub masterPublicKey
else
  create_remote_key ${USER} ${MASTER}
fi

for SLAVE in "${SLAVES[@]}"
do
	
        if ! remote_key_exists ${USER} ${SLAVE}
        then
          echo "Key does not exist! Creatin a new one"
	  create_remote_key ${USER} ${SLAVE}
        fi

        echo "Copying key from slave ${SLAVE} locally";
        scp -o StrictHostKeyChecking=no ${USER}@${SLAVE}:.ssh/id_rsa.pub slavePublicKey;

        echo "Adding slave [${SLAVE}] to authorized_hosts on master [${MASTER}]";
        cat slavePublicKey | ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} cat - ">>" .ssh/authorized_keys;
        ssh -o StrictHostKeyChecking=no ${USER}@${MASTER} "chmod 700 ~/.ssh/id_rsa";

        echo "Adding master [${MASTER}] to authorized_hosts on slave [${SLAVE}]";
        cat masterPublicKey | ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} cat - ">>" .ssh/authorized_keys;
  ssh -o StrictHostKeyChecking=no ${USER}@${SLAVE} "chmod 700 ~/.ssh/id_rsa";

done

