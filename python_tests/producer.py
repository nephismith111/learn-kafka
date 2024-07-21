import os
import time
import uuid
import random
from confluent_kafka import Producer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.json_schema import JSONSerializer
from confluent_kafka.serialization import StringSerializer, SerializationContext, MessageField

# Environment variables
HOST_K1 = os.environ.get('HOST_K1', '10.111.128.75')
PORT_EXT_K1 = os.environ.get('PORT_EXT_K1', '40110')
SCHEMA_REGISTRY_URL = os.environ.get('SCHEMA_REGISTRY_URL', 'http://10.111.128.75:40300')

# Global variable for topic
TOPIC = "event-v1-warehouse-pick_ticket-create-completed"

def delivery_report(err, msg):
    if err is not None:
        print(f'Message delivery failed: {err}')
    else:
        print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

schema_str = """
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "event-v1-warehouse-pick_ticket-create-completed",
  "description": "Event notifying that a pick ticket has been fully and successfully created",
  "version": "0.0.1",
  "type": "object",
  "properties": {
    "server": {
      "type": "string"
    },
    "db": {
      "type": "string"
    },
    "location_id": {
      "type": "integer"
    },
    "pick_ticket_no": {
      "type": "integer"
    },
    "order_no": {
      "type": "integer"
    }
  },
  "required": ["pick_ticket_no", "order_no", "location_id"],
  "additionalProperties": true
}
"""

def main():
    schema_registry_conf = {'url': SCHEMA_REGISTRY_URL}
    schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    json_serializer = JSONSerializer(schema_str, schema_registry_client)
    string_serializer = StringSerializer('utf_8')

    producer_conf = {
        'bootstrap.servers': f'{HOST_K1}:{PORT_EXT_K1}'
    }

    producer = Producer(producer_conf)

    try:
        while True:
            event = {
                "server": f"server-{random.randint(1, 100)}",
                "db": f"db-{random.randint(1, 10)}",
                "location_id": random.randint(1, 1000),
                "pick_ticket_no": random.randint(10000, 99999),
                "order_no": random.randint(100000, 999999)
            }
            producer.produce(
                topic=TOPIC,
                key=string_serializer(str(event['pick_ticket_no'])),
                value=json_serializer(event, SerializationContext(TOPIC, MessageField.VALUE)),
                on_delivery=delivery_report
            )
            producer.flush()
            print(f'Produced event: {event}')
            time.sleep(5)  # Wait for 5 seconds before sending the next message
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':
    main()