# MySQL Database Size Check
**Date:** 2025-07-04  
**Messages:** 2  
**UUID:** af91fb47-8c6e-417f-9bed-3310cb7a6b23

---

**UNKNOWN**

how do i chek the mysql databases andtasbles to se thier sized?

---
**UNKNOWN**

 Based on the script you've shared, there are several ways to check MySQL database and table sizes. Here are the methods available in your MMP Crime Database system:

## Method 1: Use the built-in `mmp_status` command
The script creates a convenient command that shows table sizes:
```bash
mmp_status
```
This will display a section showing each table with its record count and size in MB.

## Method 2: Connect directly to MySQL
Use the built-in database connection command:
```bash
mmp_db
```
Then run these SQL queries:

### Show all table sizes in the crime_data database:
```sql
SELECT 
    table_name AS 'Table',
    table_rows AS 'Records',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size_MB',
    ROUND((data_length / 1024 / 1024), 2) AS 'Data_MB',
    ROUND((index_length / 1024 / 1024), 2) AS 'Index_MB'
FROM information_schema.tables 
WHERE table_schema='crime_data'
ORDER BY (data_length + index_length) DESC;
```

### Show database size summary:
```sql
SELECT 
    table_schema AS 'Database',
    COUNT(table_name) AS 'Tables',
    SUM(table_rows) AS 'Total_Records',
    ROUND(SUM((data_length + index_length) / 1024 / 1024), 2) AS 'Total_Size_MB'
FROM information_schema.tables 
WHERE table_schema='crime_data'
GROUP BY table_schema;
```

### Show detailed breakdown by table:
```sql
SHOW TABLE STATUS FROM crime_data;
```

## Method 3: Manual MySQL connection
If you need the credentials, use:
```bash
mmp_decrypt
```
This will show you the MySQL username and password, then connect manually:
```bash
mysql -u crime_analyst -p crime_data
```

## Method 4: File system check
To see the physical MySQL data files:
```bash
sudo du -sh /var/lib/mysql/crime_data/
ls -lh /var/lib/mysql/crime_data/
```

The `mmp_status` command is probably the quickest way to get a good overview of your database sizes without needing to remember SQL commands.

---
