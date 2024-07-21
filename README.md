# Kafka Stack

## Components

1. **Kafka Broker**: Handles producers and consumers (pub/sub) and is the heart of the Kafka stack.
2. **Kafka Connect**: Supports streaming data and tasks.
3. **AKHQ**: GUI for visually working with Kafka, monitoring, and inspecting schemas.
4. **Schema Registry**: Provides an API for accessing schemas (needs to be highly available with Nginx in front).
5. **REST API**: Allows non-Kafka prepared agents to interact with Kafka.
6. **ksqlDB**: Good for querying topics.

## Support Programs

- **Terraform**: Allows for idempotent and version-controlled management of topics.

## Project Structure

The project is divided into multiple docker-compose files to enable component updates while maintaining high availability of the Kafka cluster. The main exception is the GUI (AKHQ), which does not have redundant deployment.

- When updating Kafka brokers, perform a rolling update across each `docker-compose.k[123].yml` file. Allow sufficient time to ensure cluster stability. As long as two are alive, it will remain stable. Monitor AKHQ for confirmation.
- For updating plugins in Kafka Connect services, the configuration is divided into two parts to allow job rebalancing. Allow sufficient time (minutes) before updating the second set of connect servers.
- Support services, including the Schema Registry, are in the `docker-compose.k-support.yml` file.

## Getting Started

1. Export the necessary variables to your terminal environment.
2. Deploy the Kafka brokers first, then the other components in any order.

To run this, create a `.env` file with the following variables:

```properties
ENVIRONMENT=deva
# AKHQ
PORT_AKHQ=40000
PORT_AKHQ_METRICS=40001

# Kafka Brokers
NODE_ID_K1=1
NODE_ID_K2=2
NODE_ID_K3=3
NODE_ID_K4=4
NODE_ID_K5=5

HOST_K1=<your_host_1>
HOST_K2=<your_host_2>
HOST_K3=<your_host_3>
HOST_K4=<your_host_4>
HOST_K5=<your_host_5>

PORT_EXT_K1=40110
PORT_CTL_K1=40111
PORT_PLAIN_K1=40112
PORT_METRICS_K1=40115

PORT_EXT_K2=40120
PORT_CTL_K2=40121
PORT_PLAIN_K2=40122
PORT_METRICS_K2=40125

PORT_EXT_K3=40130
PORT_CTL_K3=40131
PORT_PLAIN_K3=40132
PORT_METRICS_K3=40135

PORT_EXT_K4=40140
PORT_CTL_K4=40141
PORT_PLAIN_K4=40142
PORT_METRICS_K4=40145

PORT_EXT_K5=40150
PORT_CTL_K5=40151
PORT_PLAIN_K5=40152
PORT_METRICS_K5=40155

# Kafka Connect
PORT_CONN=40200
PORT_CONN_11=40210
PORT_CONN_12=40220
PORT_CONN_21=40230
PORT_CONN_22=40240


# Schema Registry
PORT_SCHEMA=40300
PORT_SCHEMA1=40310
PORT_SCHEMA2=40320
PORT_SCHEMA3=40330

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

# Add any additional variables used in your docker-compose files
```

Note: The default values for the Kafka Connect topics are:
- `__connect-offsets` for offset storage
- `__connect-config` for config storage
- `__connect-status` for status storage


Todo list:
* [x] Switch out connectors for Debezium connectors
* [x] Deploy the kafka stack using gitlab
* [x] Split the deployment into multiple jobs to safely update the stack
* [x] Ensure Idempotent management of topics
* [x] Publish and subscribe to basic messages
* [ ] Publish and subscribe using schema'd messages
* [ ] Setup example using open telemetry for traces
