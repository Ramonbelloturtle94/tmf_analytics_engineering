# dbt Local Setup (Snowflake + VS Code)

This guide explains how to set up dbt locally using a Python virtual environment and connect safely to Snowflake using a sandbox schema.

---

## Purpose

This repository exists to establish a safe local dbt development workflow and define future analytics engineering standards before wider team adoption.

The current project includes:

• Local dbt development environment
• Snowflake connection via sandbox schema
• Source table definitions
• Staging models
• Fact models
• Automated data testing
• Git version control
• dbt packages (dbt_utils)

This repository serves as a foundation for future analytics engineering standards across the TM forum Data team.

DBT = **Data Build Tool**

- Open-source command line tool for transforming data inside your warehouse
- Represents the **T in ELT**
- Runs SQL directly in Snowflake
- Enables version-controlled, testable transformations

---

## Prerequisites

- Install VS Code (or preferred editor)
- Install Python **3.11**
- Install Git
- Snowflake user access

---

## ⚠️ Important

Each developer must create their own:

- Python virtual environment
- `~/.dbt/profiles.yml`
- Snowflake credentials

These are **NOT** stored in GitHub.

---

# INSTALLATION STEPS

---

## 1. Create workspace folder

```bash
mkdir -p ~/dbt_workspace
cd ~/dbt_workspace

This folder will contain: 

dbt_workspace/
│
├── dbt_env/        # Python virtual environment (local only)
├── dbt_learning/   # dbt project
├── README.md
└── .gitignore

2. Create Python virtual environment (Python 3.11)

Use Python 3.11 explicitly (required for modern dbt versions).

```bash
/usr/local/bin/python3 -m venv dbt_env
source dbt_env/bin/activate
python --version

Expected output: Python 3.11.x

Your terminal prompt should now show: '(dbt_env)'

3. Install dbt packages

Install dbt Core + Snowflake adapter:

pip install -U pip
pip install "dbt-core==1.11.5" "dbt-snowflake==1.11.2"

Verify installation:
~/dbt_workspace/dbt_env/bin/dbt --version

Expected: 

Core: 1.11.x
Plugins:
  - snowflake: 1.11.x

4. Create dbt profiles folder (Snowflake connection)

dbt connection settings live outside the project.
Create the folder:
mkdir -p ~/.dbt

Open the profile file: 
code ~/.dbt/profiles.yml

Example profile (username + password) file:

dbt_learning:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT_LOCATOR
      user: YOUR_USERNAME
      password: YOUR_PASSWORD
      role: YOUR_ROLE
      warehouse: YOUR_WAREHOUSE
      database: YOUR_DATABASE
      schema: YOURNAME_DBT_SANDBOX
      threads: 4
      client_session_keep_alive: false

(If the code command isn't available)

	•	Open VS Code
	•	Cmd + Shift + P
	•	Run: Shell Command: Install ‘code’ command in PATH


Example profile: 

dbt_learning:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT
      user: YOUR_USER
      role: YOUR_SANDBOX_ROLE
      warehouse: YOUR_WAREHOUSE
      database: YOUR_SANDBOX_DATABASE
      schema: RAMON_DBT_SANDBOX
      threads: 4
      authenticator: externalbrowser
      client_session_keep_alive: false

5. Create a dbt project 

cd ~/dbt_workspace
~/dbt_workspace/dbt_env/bin/dbt init dbt_learning

When prompted, select profile: 
dbt_learning


6. Activate environment when starting work

Each new terminal session requires reactivating the environment:
cd ~/dbt_workspace
source dbt_env/bin/activate

Your prompt should now show:
(dbt_env)

7. Test connection 

Run: 
~/dbt_workspace/dbt_env/bin/dbt debug

Expected result:
'All checks passed!'

7.5 Install dbt packages (dbt_utils)

dbt packages are reusable macro libraries 

create: cd ~/dbt_workspace/dbt_learning

create packages file: 

cat > packages.yml << 'EOF'
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
EOF

Install packages: dbt deps // this creates: dbt_packages/


8. Set up Git & Git Hub 

Create .gitignore (important)

dbt_env/
dbt_learning/target/
dbt_learning/logs/
dbt_learning/dbt_packages/
dbt_learning/dbt_internal_packages/
.DS_Store
.env

Initialise: 

git init
git add .
git commit -m "Initial dbt local setup"

connect repo: 

git remote add origin https://github.com/Ramonbelloturtle94/DBTlearning.git
git branch -M main
git push -u origin main


Daily Workflow (recommended)

cd ~/dbt_workspace
source dbt_env/bin/activate
cd dbt_learning
dbt debug

optional shortcut (add to ~/.zshrc):

alias dbtwork='cd ~/dbt_workspace && source dbt_env/bin/activate'

Then run: dbtwork

What lives where? 

Stored locally only
	•	~/.dbt/profiles.yml (credentials)
	•	dbt_env/ (Python environment)

Stored in GitHub
	•	dbt models
	•	macros
	•	YAML documentation
	•	README

Quick sanity checks:
python --version
which dbt
dbt --version
git status

Command         Purpose
dbt debug       Environment health check
dbt run         Build models
dbt parse       Validate project structure
dbt test        Validate data quality
dbt build       Run everything
dbt docs generate
dbt docs serve

Data Testing with DBT:

dbt enables automated data quality testing directly inside the warehouse.

These tests validate assumptions about the data and help detect issues early.

Types of dbt tests

Generic tests

Built-in reusable tests defined in YAML.

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


Project Structure:


models/
│
├── staging
│   └── ods
│       ├── stg_travellers.sql
│       ├── stg_trip_bookings.sql
│       └── schema.yml
│
├── marts
│   └── training
│       └── fct_trip_bookings.sql
│
└── sandbox
    ├── my_first_dbt_model.sql
    └── my_second_dbt_model.sql