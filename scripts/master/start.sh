#!/bin/bash
#starter

ROOT=$(dirname ${0})

source ${ROOT}/env.sh


echo ""
echo "--- LAUNCHING SCRIPTS ---"

echo "Starting GossipRouter"
java -cp ${MASTER_ROOT_DIR}/RadarGun-1.1.0-SNAPSHOT/plugins/infinispan4/lib/jgroups-3.4.0.Alpha1.jar org.jgroups.stack.GossipRouter -port 15800 -bindaddress ${MASTER} &

sleep 5

echo "Starting LogService"
pushd ${MASTER_ROOT_DIR}/monitor/wpm
  bash ./run_log_service.sh 2>&1 > ./log/log_service.out &
popd

sleep 5

echo "Starting Master"
pushd ${MASTER_ROOT_DIR}/RadarGun-1.1.0-SNAPSHOT
  bash ./bin/master.sh -stop && sleep 5 && ./bin/master.sh -m ${MASTER}
popd


echo ""
echo "--- DONE"


tail -f ${MASTER_ROOT_DIR}/RadarGun-1.1.0-SNAPSHOT/stdout_master.out
