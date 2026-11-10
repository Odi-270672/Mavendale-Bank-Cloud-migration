# Mavendale Bank — Project Progress Journal

## Phase 1 — Infrastructure, Automation and Application Deployment

### Completed milestones

- Provisioned Azure networking, four subnets, NSGs and Web/App VMs using Terraform.
- Configured remote Terraform state storage in Azure.
- Implemented Azure DevOps Terraform CI/CD Pipelines.
- Automated Web-tier Nginx deployment using Ansible.
- Developed and locally tested the Python Banking API.

### Day 9 — Banking API Deployment (4 November 2026)

**Objective:** Deploy and verify the Banking API on the private Azure App VM.

**Implementation**
- Created an Ansible App-tier playbook with Python installation, application directory creation, API deployment and systemd service configuration.
- Validated the playbook using `ansible-playbook --syntax-check`.
- Configured temporary SSH access through the Web VM, without assigning a Public IP to the App VM.
- Used SSH ProxyCommand and `ssh-add` to resolve jump-host authentication issues.
- Successfully deployed the Banking API using Ansible.

**Validation**
- Ansible deployment: 6 tasks successful, 0 failures.
- App VM health endpoint: HTTP 200 OK.
- Web-to-App connectivity: HTTP 200 OK over TCP 8080.
- Removed temporary Web-to-App SSH access and confirmed API connectivity remained functional.

**Key learning:** SSH management access and application traffic are independently controlled through Azure NSG rules.

**Next milestone:** Implement the database tier and establish application-to-database connectivity.

## Day 10 — Azure SQL Provisioning Investigation

**Objective:** Provision the Mavendale Bank Azure SQL logical server and database using Terraform.

**Terraform resources:**
- `azurerm_mssql_server.mavendale_sql_server`
- `azurerm_mssql_database.mavendale_database`

**Issue encountered:**
- Terraform deployment failed with `ProvisioningDisabled`.
- Azure SQL provisioning was restricted in UK South and UK West.
- Azure SQL quota checks showed available capacity, indicating that the issue was not simply exhausted quota.
- Subscription `SUB-PASO-001` uses Azure Sponsorship.

**Actions taken:**
- Verified subscription status and SQL resource-provider registration.
- Checked Azure SQL quotas.
- Submitted an Azure Support request for SQL Database region access in UK West.
- Discussed the issue with Microsoft Support.

**Support request:** `2611050050003669`

**Current status:** Microsoft Support has escalated the request to its internal team. Awaiting confirmation of region access.

**Decision:** Continue App Tier development and Ansible automation while Azure SQL provisioning remains blocked.

**Lesson learned:** Available Azure resource quotas do not necessarily guarantee provisioning access. Subscription-level restrictions can prevent resource creation even when Terraform validation and planning succeed.
