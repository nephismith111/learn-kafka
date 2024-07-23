#!/bin/bash

# Create an external overlay network for Kafka and Schema Registry
docker network create --driver overlay --attachable ks_schema_network
