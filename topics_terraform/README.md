# Kafka Topic Management with Terraform

This project uses Terraform to manage Kafka topics in a GitLab CI/CD pipeline.

## Usage

Users should only use GitLab to apply the topics. They shouldn't have to run this manually. The GitLab CI/CD pipeline will handle the execution of Terraform commands.

## Topic Naming Convention

Topics are organized in files named `topics-<department>.tf`. For example, warehouse-related topics are stored in `topics-warehouse.tf`.

### Naming Patterns

- Full pattern: `<evt|cmd>.<department>.<sub-domain>.<sub department>.<state + status|desired state>`

#### Example Events:
- evt-sales-order-create-started
- evt-sales-order-create-finished
- evt-warehouse-pick_ticket-create-started
- evt-warehouse-pick_ticket-create-failed
- evt-purchasing-purchase_order-create-started

#### Example Commands:
- cmd-warehouse-pick_ticket-create
- cmd-sales-order-update
- cmd-inventory-item-delete
- cmd-purchasing-purchase_order-approve
- cmd-returns-authorization-create


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
resource "kafka_topic" "evt-warehouse-pick_ticket-create-started" {
    name                    = "evt-warehouse-pick_ticket-create-started"
    replication_factor      = 3
    partitions              = 15
}

resource "kafka_topic" "evt-warehouse-pick_ticket-create-failed" {
    name                    = "evt-warehouse-pick_ticket-create-failed"
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

## *SEARCH/REPLACE block* Rules

When proposing changes to files in this project, always use the *SEARCH/REPLACE block* format:

1. File path on a single line, verbatim (no formatting or quotes).
2. Opening fence and code language, e.g., <source>hcl
3. Start of search block: <<<<<<< SEARCH
4. Exact lines to search for in the existing code
5. Dividing line: =======
6. Lines to replace in the source code
7. End of replace block: >>>>>>> REPLACE
8. Closing fence: </source>

### Important Notes:
- The *SEARCH* section must exactly match the existing code, including comments and whitespace.
- *SEARCH/REPLACE* blocks replace all matching occurrences.
- Keep blocks concise, focusing on changing lines and minimal surrounding context.
- Only create blocks for files explicitly added to the conversation.
- To move code within a file, use two separate blocks: one to delete, one to insert.
- For new files, use an empty *SEARCH* section and put the new content in the *REPLACE* section.

Always use this format when proposing code changes to ensure clarity and prevent errors in file modifications.
