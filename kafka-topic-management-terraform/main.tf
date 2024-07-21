# main.tf
terraform {
    required_providers {
        kafka = {
            source = "Mongey/kafka"
            version = "~> 0.7.1"
        }
    }
}

variable "kafka_bootstrap_servers" {
    type = list(string)
    description = "List of Kafka bootstrap servers"
}

provider "kafka" {
    bootstrap_servers = var.kafka_bootstrap_servers
    tls_enabled       = false
}
