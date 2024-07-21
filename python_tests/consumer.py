import os
from confluent_kafka import Consumer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.json_schema import JSONDeserializer
from confluent_kafka.serialization import StringDeserializer

# Environment variables
HOST_K1 = os.environ.get('HOST_K1', '10.111.128.75')
PORT_EXT_K1 = os.environ.get('PORT_EXT_K1', '40110')
SCHEMA_REGISTRY_URL = os.environ.get('SCHEMA_REGISTRY_URL', 'http://10.111.128.75:40300')

# Global variable for topic
TOPIC = "event-v1-warehouse-pick_ticket-create-completed"

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

    json_deserializer = JSONDeserializer(schema_str)
    string_deserializer = StringDeserializer('utf_8')

    consumer_conf = {
        'bootstrap.servers': f'{HOST_K1}:{PORT_EXT_K1}',
        'group.id': 'test-consumer-group',
        'auto.offset.reset': 'earliest'
    }

    consumer = Consumer(consumer_conf)
    consumer.subscribe([TOPIC])

    try:
        while True:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                print(f"Consumer error: {msg.error()}")
                continue

            key = string_deserializer(msg.key())
            value = json_deserializer(msg.value(), None)

            print(f"Received message:")
            print(f"Key: {key}")
            print(f"Value: {value}")
            print(f"Partition: {msg.partition()}")
            print(f"Offset: {msg.offset()}")
            print("--------------------")
    except KeyboardInterrupt:
        pass
    finally:
        consumer.close()


if __name__ == '__main__':
    main()
