# Kafka Topic Management with Terraform

This project uses Terraform to manage Kafka topics in a GitLab CI/CD pipeline.

## Usage

Users should only use GitLab to apply the topics. They shouldn't have to run this manually. The GitLab CI/CD pipeline will handle the execution of Terraform commands.

## Topic Naming Convention

Topics are organized in files named `topics-<department>.tf`. For example, warehouse-related topics are stored in `topics-warehouse.tf`.

### Naming Patterns

- Full pattern: `<event|command>.<version v[0-9]>.<department>.<sub-domain>.<sub department>.<state + status|desired state>`

#### Example Events:
- event.v1.sales.order.create.started
- event.v1.sales.order.create.finished
- event.v1.warehouse.pick_ticket.create.started
- event.v1.warehouse.pick_ticket.create.failed
- event.v1.purchasing.purchase_order.create.started

#### Example Commands:
- command.v2.warehouse.pick_ticket.create
- command.v1.sales.order.update
- command.v1.inventory.item.delete
- command.v3.purchasing.purchase_order.approve
- command.v2.returns.authorization.create


### Status:
- State of a task: started, completed, failed, skipped
- Standard Log levels: debug, info, warning, error, critical

### Desired State:
- Standard CRUD operations (less Read): create, update, delete
- Idempotent desired states (like ansible): present, absent
- Process-like state management: start, stop, restart, halt

## Example Topics

Here are two example topics from `topics-warehouse.tf`:

```hcl
resource "kafka_topic" "event-v1-warehouse-pick_ticket-create-started" {
    name                    = "event.v1.warehouse.pick_ticket.create.started"
    replication_factor      = 3
    partitions              = 15
}

resource "kafka_topic" "event-v1-warehouse-pick_ticket-create-failed" {
    name                    = "event.v1.warehouse.pick_ticket.create.failed"
    replication_factor      = 3
    partitions              = 15
}
```

## Departments and Sub-Departments

- Corporate: Productivity Reports, Profitability Reports, System Alerts, Sensitive usage alerts
- Accounting: customer_management, accounts_receivable, accounts_payable
- Marketing
- Purchasing: Managerial Approval, Purchase Order
- Returns: Authorization
- Data Support
- Inventory: supplier_pricing, customer_pricing, production_order, classification, item_search
- IT Software: infrastructure alert, Hardware, Software
- Finance: Taxes, Report
- Sales: Order, Order stuck in the system
- Warehouse: Pick Tickets, Shipping, Transfers, Put away, Cycle Counts

For more detailed information on departments and sub-departments, refer to the comments in the `main.tf` file.
