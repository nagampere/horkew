## Introduction


## Set up

```bash
$ poetry install
```

## dbt run

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
D select * from information_schema.tables;
```

## Analysis
```python
import duckdb

# create a connection to a file called 'file.db'
con = duckdb.connect("../projects/${TENANT_NAME}/dbt/catalog.duckdb")
# create a table and load data into it
con.sql("CREATE TABLE test (i INTEGER)")
con.sql("INSERT INTO test VALUES (42)")
# query the table
con.table("test").show()
# explicitly close the connection
con.close()
# Note: connections also closed implicitly when they go out of scope
```
