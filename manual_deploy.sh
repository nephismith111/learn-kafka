#!/bin/bash

# Function to deploy a stack
deploy_stack() {
    local stack_name=$1
    local compose_file=$2
    echo "Deploying $stack_name..."
    docker stack deploy -c $compose_file $stack_name
    echo "$stack_name deployed. Waiting 5 seconds..."
    sleep 5
}

# Check if .env file exists
if [ ! -f .env ]; then
    echo ".env file not found. Creating one..."
    
    # Ask for host IP
    read -p "Enter your host IP (e.g., 192.168.1.110): " host_ip
    
    # Create .env file
    cat > .env << EOL
ENVIRONMENT=deva
# AKHQ
PORT_AKHQ=40000
PORT_AKHQ_METRICS=40001

# Kafka Brokers
NODE_ID_K1=1
NODE_ID_K2=2
NODE_ID_K3=3

HOST_K1=$host_ip
HOST_K2=$host_ip
HOST_K3=$host_ip

PORT_EXT_K1=40110
PORT_CTL_K1=40111
PORT_METRICS_K1=40112

PORT_EXT_K2=40120
PORT_CTL_K2=40121
PORT_METRICS_K2=40122

PORT_EXT_K3=40130
PORT_CTL_K3=40131
PORT_METRICS_K3=40132

# Kafka Connect
PORT_CONN_1=40210
PORT_CONN_2=40220
PORT_CONN_3=40230
PORT_CONN_4=40240

# Schema Registry
PORT_SCHEMA=40300
PORT_SCHEMA1=40310
PORT_SCHEMA2=40320

# ksqlDB
PORT_KSQLDB=40400

# Rest API
PORT_RESTAPI=40500

# Confluent Version
CONFLUENT_VERSION=7.6.1

# Kafka Connect Topics
CONNECT_OFFSET_STORAGE_TOPIC=__connect-offsets
CONNECT_CONFIG_STORAGE_TOPIC=__connect-config
CONNECT_STATUS_STORAGE_TOPIC=__connect-status

# Kafka Connect Group ID
CONNECT_GROUP_ID=kafka-connect
EOL

    echo ".env file created successfully."
fi

# Set environment variables
set -a
source .env

# Deploy stacks
deploy_stack "ks_kafka1" "docker-compose.k1.yml"
deploy_stack "ks_kafka2" "docker-compose.k2.yml"
deploy_stack "ks_kafka3" "docker-compose.k3.yml"
deploy_stack "ks_connect-1" "docker-compose.k-connect-1.yml"
deploy_stack "ks_connect-2" "docker-compose.k-connect-2.yml"
deploy_stack "ks_support" "docker-compose.k-support.yml"

echo "All stacks deployed successfully."
