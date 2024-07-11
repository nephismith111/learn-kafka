# main.tf

terraform {
    required_providers {
        kafka = {
            source = "Mongey/kafka"
            version = "~> 0.7.1"
        }
    }
}

provider "kafka" {
    bootstrap_servers       = ["192.168.86.183:9092","172.19.0.2:9092"] 
    tls_enabled             = false
    # version           = "3.7.0"
    # bootstrap_servers = ["localhost:9092"] 
    #var.kafka_bootstrap_servers
}

## How to use. Export your bootstrap servers var, then call `apply` with the vars file
# Export TF_VAR_kafka_bootstrap_servers='["localhost:9092"]'
# terraform apply -var-file=vars=def.tfvars
#####



## Kafka Topics below this point

resource "kafka_topic" "topic1" {
    name                    =   "topic1"
    replication_factor      =   1
    partitions              =   1
}

# resource "kafka_topic" "topic2" {
#     name                    =   "topic2"
#     replication_factor      =   var.replication_factor
#     partitions              =   var.partitions
    
# }

