variable "environment" {
    description = "Deployment environment: dev, prod, etc"
    type = string
}

variable "replication_factor" {
    description = "default replication factor for topics"
    type = number
}

variable "partitions" {
    description = "Default number of partitions per topics"
    type = number
}

variable "kafka_bootstrap_servers" {
    description = "Comma-separated lsit of kafka broker addressses"
    type = list(string)
}


