

```python
import mysql.connector
from mysql.connector import errorcode
```


```python
# Obtain connection string information from the portal
config = {
  'host':'andromeda',
  'user':'root',
  'password':'qNlr0rZtf5VfGQ9m',
  'database':'information_schema'
}
```


```python
conn = mysql.connector.connect(**config)
```


```python
cursor = conn.cursor()
```


```python
# Read data
cursor.execute("SHOW TABLES;")
rows = cursor.fetchall()
print("Read",cursor.rowcount,"row(s) of data.")

# Print all rows
for row in rows:
  print("Data row = (%s)" %(str(row[0])))
```

    ('Read', 75, 'row(s) of data.')
    Data row = (ALL_PLUGINS)
    Data row = (APPLICABLE_ROLES)
    Data row = (CHARACTER_SETS)
    Data row = (COLLATIONS)
    Data row = (COLLATION_CHARACTER_SET_APPLICABILITY)
    Data row = (COLUMNS)
    Data row = (COLUMN_PRIVILEGES)
    Data row = (ENABLED_ROLES)
    Data row = (ENGINES)
    Data row = (EVENTS)
    Data row = (FILES)
    Data row = (GLOBAL_STATUS)
    Data row = (GLOBAL_VARIABLES)
    Data row = (KEY_CACHES)
    Data row = (KEY_COLUMN_USAGE)
    Data row = (PARAMETERS)
    Data row = (PARTITIONS)
    Data row = (PLUGINS)
    Data row = (PROCESSLIST)
    Data row = (PROFILING)
    Data row = (REFERENTIAL_CONSTRAINTS)
    Data row = (ROUTINES)
    Data row = (SCHEMATA)
    Data row = (SCHEMA_PRIVILEGES)
    Data row = (SESSION_STATUS)
    Data row = (SESSION_VARIABLES)
    Data row = (STATISTICS)
    Data row = (SYSTEM_VARIABLES)
    Data row = (TABLES)
    Data row = (TABLESPACES)
    Data row = (TABLE_CONSTRAINTS)
    Data row = (TABLE_PRIVILEGES)
    Data row = (TRIGGERS)
    Data row = (USER_PRIVILEGES)
    Data row = (VIEWS)
    Data row = (GEOMETRY_COLUMNS)
    Data row = (SPATIAL_REF_SYS)
    Data row = (CLIENT_STATISTICS)
    Data row = (INDEX_STATISTICS)
    Data row = (INNODB_SYS_DATAFILES)
    Data row = (USER_STATISTICS)
    Data row = (INNODB_SYS_TABLESTATS)
    Data row = (INNODB_LOCKS)
    Data row = (INNODB_TABLESPACES_SCRUBBING)
    Data row = (INNODB_CMPMEM)
    Data row = (INNODB_CMP_PER_INDEX)
    Data row = (INNODB_CMP)
    Data row = (INNODB_FT_DELETED)
    Data row = (INNODB_CMP_RESET)
    Data row = (INNODB_LOCK_WAITS)
    Data row = (TABLE_STATISTICS)
    Data row = (INNODB_TABLESPACES_ENCRYPTION)
    Data row = (INNODB_BUFFER_PAGE_LRU)
    Data row = (INNODB_SYS_FIELDS)
    Data row = (INNODB_CMPMEM_RESET)
    Data row = (INNODB_SYS_COLUMNS)
    Data row = (INNODB_FT_INDEX_TABLE)
    Data row = (INNODB_CMP_PER_INDEX_RESET)
    Data row = (user_variables)
    Data row = (INNODB_FT_INDEX_CACHE)
    Data row = (INNODB_SYS_FOREIGN_COLS)
    Data row = (INNODB_FT_BEING_DELETED)
    Data row = (INNODB_BUFFER_POOL_STATS)
    Data row = (INNODB_TRX)
    Data row = (INNODB_SYS_FOREIGN)
    Data row = (INNODB_SYS_TABLES)
    Data row = (INNODB_FT_DEFAULT_STOPWORD)
    Data row = (INNODB_FT_CONFIG)
    Data row = (INNODB_BUFFER_PAGE)
    Data row = (INNODB_SYS_TABLESPACES)
    Data row = (INNODB_METRICS)
    Data row = (INNODB_SYS_INDEXES)
    Data row = (INNODB_SYS_VIRTUAL)
    Data row = (INNODB_MUTEXES)
    Data row = (INNODB_SYS_SEMAPHORE_WAITS)



```python
  # Cleanup
  conn.commit()
  cursor.close()
  conn.close()
  print("Done.")
```

    Done.

