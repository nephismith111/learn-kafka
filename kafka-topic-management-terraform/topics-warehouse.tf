


#resource "kafka_topic" "event-v1-warehouse-pick_ticket-create-started" {
#    name                    =   "event.v1.warehouse.pick_ticket.create.started"
#    replication_factor      =   3
#    partitions              =   12
#}
#
#resource "kafka_topic" "event-v1-warehouse-pick_ticket-create-failed" {
#    name                    =   "event.v1.warehouse.pick_ticket.create.failed"
#    replication_factor      =   3
#    partitions              =   12
#}


#########
resource "kafka_topic" "event-v1-warehouse-pick_ticket-create-completed" {
    name                    =   "event-v1-warehouse-pick_ticket-create-completed"
    replication_factor      =   3
    partitions              =   6  # extremely low throughput - like 1x/10s
}
