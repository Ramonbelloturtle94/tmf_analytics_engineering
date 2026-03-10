# dbt Analytics Engineering Environment

Snowflake + dbt + VS Code Local Development

This repository establishes a local dbt development workflow connected to Snowflake using individual sandbox schemas.

Providing a foundation for introducing analytics engineering standards across the TM Forum Data Team.

Snowflake Source Tables
│
├── TRAVELLERS
└── TRIP_BOOKINGS
        │
        │  (dbt source definitions)
        ▼
Staging Layer
│
├── stg_travellers
└── stg_trip_bookings
        │
        │  (dbt ref() dependency)
        ▼
Mart Layer
│
└── fct_trip_bookings
        │
        ▼
Analytics / Reporting Layer


---

## Purpose

This project demonstrates a modern analytics engineering workflow using dbt (Data Build Tool).

The repository includes:

• Local dbt development environment
• Snowflake connection via sandbox schema
• Source table definitions
• Staging models
• Fact models
• Automated data testing
• Git version control
• dbt packages (dbt_utils)

This repository acts as a template for future data modelling and transformation workflows.

## What is dbt?

dbt (Data Build Tool) is an open-source framework used to transform data inside a data warehouse.

It represents the T in ELT.

Key capabilities:

• SQL-based data transformations
• Version-controlled data pipelines
• Data testing and validation
• Documentation generation
• Data lineage visualisation

dbt runs transformations directly inside Snowflake.

---
## Architecture Overview

The data pipeline follows a standard analytics engineering structure:

RAW TABLES
   ↓
STAGING MODELS
   ↓
FACT / DIMENSION MODELS
   ↓
ANALYTICS LAYER

Example lineage in this project:

TRAVELLERS (source table)
    ↓
stg_travellers
    ↓
fct_trip_bookings

dbt manages dependencies automatically using:
{{ ref('model_name') }}
{{ source('source_name','table_name') }} (staging)

## Repository Structure 

tmf_analytics_engineering/
│
├── models
│
│   ├── staging
│   │   └── ods
│   │       ├── stg_travellers.sql
│   │       ├── stg_trip_bookings.sql
│   │       └── schema.yml
│   │
│   ├── marts
│   │   └── training
│   │       └── fct_trip_bookings.sql
│   │
│   └── sandbox
│       ├── my_first_dbt_model.sql
│       └── my_second_dbt_model.sql
│
├── macros
├── tests
├── seeds
├── snapshots
│
├── dbt_project.yml
├── packages.yml
└── README.md

Model layers

Staging
	•	Cleans raw data
	•	Minimal transformations

Marts
	•	Fact / dimension models
	•	Business logic applied

Sandbox
	•	Experimental or learning models

## Common dbt Commands

Command             Purpose
dbt debug           Environment health check
dbt run             Build models
dbt parse           Validate project structure
dbt test            Validate data quality
dbt build           Run everything
dbt docs generate   Generate Documentation
dbt docs serve      Launch Documentation Site

## Data Testing with dbt

dbt enables automated data quality testing directly inside the warehouse.

These tests validate assumptions about the data and help detect issues early.

Generic tests

Built-in tests defined in YAML.

Test                    Purpose

not_null                column cannot contain nulls
unique                  values must be unique
accepted_values         column must match allowed values
relationships           foreign key validation 

Example: 

models:
  - name: stg_travellers
    columns:
      - name: traveller_id
        tests:
          - not_null
          - unique

run tests with: dbt test


## Local Environment Setup

Prerequisites 
	• VS Code
	•	Python 3.11
	•	Git
	•	Snowflake user access

---

## ⚠️ Important

Each developer must create their own:

- Python virtual environment
- `~/.dbt/profiles.yml`
- Snowflake credentials

These are not stored in GitHub.

---

# INSTALLATION STEPS

---

1. Create workspace folder

mkdir -p ~/dbt_workspace
cd ~/dbt_workspace

This folder will contain: 

dbt_workspace/
│
├── dbt_env/        # Python virtual environment (local only)
├── tmf_analytics_engineering/   # dbt project
└── README.md


2. Create Python virtual environment 

/usr/local/bin/python3 -m venv dbt_env
source dbt_env/bin/activate
python --version

Expected output: Python 3.11.x

3. Install dbt

pip install -U pip
pip install "dbt-core==1.11.5" "dbt-snowflake==1.11.2"

Verify:
dbt --version

Expected: 

Core: 1.11.x
Plugins:
  - snowflake: 1.11.x

4. Create dbt profile:

mkdir -p ~/.dbt
code ~/.dbt/profiles.yml

Example configuration: 

tmf_analytics_engineering:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT
      user: YOUR_USER
      role: YOUR_ROLE
      warehouse: YOUR_WAREHOUSE
      database: YOUR_DATABASE
      schema: YOURNAME_DBT_SANDBOX
      threads: 4
      authenticator: externalbrowser


5. Test Connection

dbt debug 

Expected result: "All checks passed!"


6. Install dbt packages

Create packages.yml:

packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0

Install: dbt deps 

## Git Setup

Create .gitignore:

dbt_env/
target/
logs/
dbt_packages/
.DS_Store
.env

Initialise repo: 

git init
git add .
git commit -m "Initial dbt local setup"

## Daily Workflow: 

Activate environment:

cd ~/dbt_workspace
source dbt_env/bin/activate
cd tmf_analytics_engineering

Run health check: dbt debug 

Build models: dbt build 

## Optional shortcut 

Add to ~/.zshrc: alias dbtwork='cd ~/dbt_workspace && source dbt_env/bin/activate'

Then run: dbtwork

## What lives where

Stored locally only
	•	~/.dbt/profiles.yml (credentials)
	•	dbt_env/ (Python environment)

Stored in GitHub
	•	dbt models
	•	macros
  • tests
	•	documentation
	•	README

## Future Improvements 

Next scheduled enhancements to this environment: 
• Incremental models
• Snapshotting (slowly changing dimensions)
• CI/CD pipeline integration
• Production environments
• Data contracts
• Automated documentation hosting
