nohup ./run_consumer.sh 2>&1 > consumer.out &
sleep 5
nohup ./run_producer.sh 2>&1 > producer.out &
