# After installing cockroach ... (NB: Not docker)
# https://www.cockroachlabs.com/docs/stable/start-a-local-cluster.html

# Start the first node
cockroach start --insecure --host=localhost

# Add Nodes to the cluster
cockroach start --insecure \
--store=node2 \
--host=localhost \
--port=26258 \
--http-port=8081 \
--join=localhost:26257

cockroach start --insecure \
--store=node3 \
--host=localhost \
--port=26259 \
--http-port=8082 \
--join=localhost:26257

# Test the cluster
cockroach sql --insecure
CREATE DATABASE bank;
CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
INSERT INTO bank.accounts VALUES (1, 1000.50);
SELECT * FROM bank.accounts;
\q

# Go to second node
cockroach sql --insecure --port=26258
SELECT * FROM bank.accounts;
\q

# Access the cluster
# http://localhost:8080

# Stop the main node with CTRL+C
# Test the remaining clusters
cockroach sql --insecure --port=26258
SELECT * FROM bank.accounts;
\q

# Stop node 2 and 3 with CTRL+C
# Remove the data if you do not want to restart the cluster
rm -rf cockroach-data node2 node3

# If you want to restart the cluster you need to restart at least two nodes
