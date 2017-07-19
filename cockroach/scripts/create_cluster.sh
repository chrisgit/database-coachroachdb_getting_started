docker network create -d bridge roachnet

mkdir -p /opt/cockroachdb/roach1

docker run -d \
--name=roach1 \
--hostname=roach1 \
--net=roachnet \
-p 26257:26257 -p 8080:8080 \
-v "/opt/cockroachdb/roach1:/cockroach/cockroach-data" \
-v "/opt/cockroach/scripts:/scripts" \
cockroachdb/cockroach:v1.0.3 start --insecure

mkdir -p /opt/cockroachdb/roach2

docker run -d \
--name=roach2 \
--hostname=roach2 \
--net=roachnet \
-v "/opt/cockroachdb/roach2:/cockroach/cockroach-data" \
cockroachdb/cockroach:v1.0.3 start --insecure --join=roach1

mkdir -p /opt/cockroachdb/roach3

docker run -d \
--name=roach3 \
--hostname=roach3 \
--net=roachnet \
-v "/opt/cockroachdb/roach3:/cockroach/cockroach-data" \
cockroachdb/cockroach:v1.0.3 start --insecure --join=roach1
