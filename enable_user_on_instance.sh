#!/bin/bash

set -e
set +x

source ./env.sh

FROM_USER=$1
TO_USER=$2


ssh -o StrictHostKeyChecking=no ${FROM_USER}@${MASTER} "sudo cp /home/${FROM_USER}/.ssh/authorized_keys /${TO_USER}/.ssh/"

for SLAVE in "${SLAVES[@]}"
do
  ssh -o StrictHostKeyChecking=no ${FROM_USER}@${SLAVE} "sudo cp /home/${FROM_USER}/.ssh/authorized_keys /${TO_USER}/.ssh/"
done


