## Introduction


## Set up

```bash
$ poetry install
```

## Run

```bash
$ cd projects/${TENANT_NAME}/dbt
$ poetry run dbt deps 

# run all dbt models
$ poetry run dbt run 
# run a selected model
$ poetry run dbt run  --select ${MODEL_NAME} 
```

```bash
# check tables in Duckdb
$ poetry run duckdb catalog.duckdb
D select * from information_schema.tables
```
