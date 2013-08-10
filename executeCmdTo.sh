#!/bin/bash

set -e
set +x

EXPECTED_ARGS=2

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` <TARGET> <COMMAND>"
  exit -1
fi

CMD=$2
TARGET=$1

USER=root
MACHINES=`grep -v "^#"  < node_ips | grep "^${TARGET}" | cut -d':' -f2 `

for ip in ${MACHINES}
do
	(ssh -o StrictHostKeyChecking=no $USER@$ip ${CMD}) &
done

echo "${CMD} executed"

