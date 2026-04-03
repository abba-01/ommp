# MMP Crime Database Script Troubleshooting
**Date:** 2025-07-04  
**Messages:** 10  
**UUID:** e7fd562b-ae4f-4ed6-907a-dc69905ef73c

---

**UNKNOWN**

📚 MMP CRIME DATABASE HELP
                     [Installation ID: 98A90AC8]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 MONITORING COMMANDS:
  mmp_status      - Complete system dashboard with downloads
  mmp_check       - Check download completion status
  mmp_security    - Security configuration status
🗄️ DATABASE COMMANDS:
  mmp_db          - Direct database access
  mmp_unified     - Unified data analysis
  mmp_load        - Load data after downloads complete
🔐 SECURITY COMMANDS:
  mmp_decrypt     - Decrypt stored credentials
🆔 SYSTEM INFO:
  Installation ID: 98A90AC8
  Recovery: Use passphrase with mmp_decrypt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@two ~]# mmp_load
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📊 MMP DATA LOADING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All files downloaded. Starting data load...
⚠️  Note: Data loading functionality needs to be implemented.
This would load data from CSV files into the database tables.
For now, you can manually load data or wait for the implementation.
[root@two ~]# ./mmp_crime_complete_v08_corrected.sh

I thought this was supposed to automatically run the mmp_load in teh script did wre miss it

---
**UNKNOWN**


Looking at the script, I can see that it creates the `mmp_load` command but doesn't automatically execute it. The script:

1. Starts the downloads in the background (using `wget -b`)
2. Creates all the utility commands including `mmp_load`
3. Finishes and shows the summary

The script expects you to:
1. Wait for downloads to complete (monitor with `mmp_check`)
2. Manually run `mmp_load` once downloads are done

However, I notice that the `mmp_load` command created by the script is just a placeholder that says "Data loading functionality needs to be implemented." 

To add automatic loading or a proper implementation, you would need to either:

1. **Add a proper mmp_load implementation** that actually loads the CSV files into the database
2. **Add an automatic loader** that runs after downloads complete

Would you like me to help create a proper `mmp_load` implementation that actually loads the data into the MySQL tables? Or would you prefer to add an automatic loading mechanism to the script?

---
**UNKNOWN**

comapre it against this to see if oti was left out

---
**UNKNOWN**


Looking at both scripts, I can see the issue. **Both versions create `mmp_load` as a placeholder only** - neither actually implements the data loading functionality.

In the main script (v08_corrected), `mmp_load` is created with:
```bash
cat > /usr/local/bin/mmp_load << 'EOF'
#!/bin/bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    📊 MMP DATA LOADING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if downloads are complete using mmp_check
if ! mmp_check | grep -q "ALL DOWNLOADS COMPLETE"; then
    echo "❌ Downloads not complete. Run mmp_check to see status."
    exit 1
fi

echo "✅ All files downloaded. Starting data load..."
echo ""
echo "⚠️  Note: Data loading functionality needs to be implemented."
echo "This would load data from CSV files into the database tables."
echo ""
echo "For now, you can manually load data or wait for the implementation."
EOF
```

This is just a placeholder that tells you the functionality needs to be implemented.

**What's missing is the actual data loading code.** The script should include a Python script or MySQL LOAD DATA commands to actually import the CSV files into the database tables.

Would you like me to create a proper `mmp_load` implementation that actually loads the data from the CSV files into the MySQL tables? I can create a version that:
1. Checks download completion
2. Loads each CSV file into its respective table
3. Shows progress during loading
4. Populates the unified_crimes table
5. Reports success/failure

---
**UNKNOWN**

update the v8 please by just generating the mmp_load code and tell mne where ot oadd it into the script,. thank you

---
**UNKNOWN**


Here's the proper `mmp_load` implementation to replace the placeholder in the v08_corrected script:

**Replace the existing `mmp_load` creation** (around lines 1030-1050) with this code:

```bash
# Create mmp_load with actual data loading functionality
cat > /usr/local/bin/mmp_load << 'EOF'
#!/bin/bash
# mmp_load - Load crime data CSV files into MySQL database

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    📊 MMP DATA LOADING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if downloads are complete
if ! mmp_check | grep -q "ALL DOWNLOADS COMPLETE"; then
    echo -e "${RED}❌ Downloads not complete. Run mmp_check to see status.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All files downloaded. Starting data load...${NC}"
echo ""

# Get MySQL credentials
MYSQL_PASS=$(grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)

if [ -z "$MYSQL_PASS" ]; then
    echo -e "${RED}❌ Cannot retrieve MySQL credentials${NC}"
    exit 1
fi

# Test database connection
if ! mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "SELECT 1;" &>/dev/null; then
    echo -e "${RED}❌ Cannot connect to database${NC}"
    exit 1
fi

# Function to load Chicago data
load_chicago() {
    echo -e "${BLUE}Loading Chicago crime data...${NC}"
    local file="/data/crime_data/raw/chicago.csv"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Chicago data file not found${NC}"
        return 1
    fi
    
    # Get file size for progress tracking
    local filesize=$(stat -c%s "$file" 2>/dev/null)
    local filesize_mb=$((filesize / 1024 / 1024))
    echo -e "${WHITE}  File size: ${filesize_mb}MB${NC}"
    
    # Create temporary loading script
    cat > /tmp/load_chicago.sql << 'SQLEOF'
SET SESSION sql_mode = '';
SET SESSION foreign_key_checks = 0;

TRUNCATE TABLE chicago_crimes;

LOAD DATA LOCAL INFILE '/data/crime_data/raw/chicago.csv'
INTO TABLE chicago_crimes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8,
    @col9, @col10, @col11, @col12, @col13, @col14, @col15,
    @col16, @col17, @col18, @col19, @col20, @col21, @col22
)
SET
    case_number = NULLIF(@col1, ''),
    date = STR_TO_DATE(@col2, '%m/%d/%Y %h:%i:%s %p'),
    block = NULLIF(@col3, ''),
    iucr = NULLIF(@col4, ''),
    primary_type = NULLIF(@col5, ''),
    description = NULLIF(@col6, ''),
    location_description = NULLIF(@col7, ''),
    arrest = IF(@col8 = 'true', 1, 0),
    domestic = IF(@col9 = 'true', 1, 0),
    beat = NULLIF(@col10, ''),
    district = NULLIF(@col11, ''),
    ward = NULLIF(@col12, ''),
    community_area = NULLIF(@col13, ''),
    fbi_code = NULLIF(@col14, ''),
    x_coordinate = NULLIF(@col15, ''),
    y_coordinate = NULLIF(@col16, ''),
    year = NULLIF(@col17, ''),
    updated_on = STR_TO_DATE(@col18, '%m/%d/%Y %h:%i:%s %p'),
    latitude = NULLIF(@col19, ''),
    longitude = NULLIF(@col20, ''),
    location = NULLIF(@col21, '');
SQLEOF

    # Load data
    mysql --local-infile=1 -u crime_analyst -p"$MYSQL_PASS" crime_data < /tmp/load_chicago.sql 2>/dev/null
    
    if [ $? -eq 0 ]; then
        local count=$(mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "SELECT COUNT(*) FROM chicago_crimes;" -s -N 2>/dev/null)
        echo -e "${GREEN}  ✓ Loaded $(printf "%'d" $count) Chicago records${NC}"
        rm -f /tmp/load_chicago.sql
        return 0
    else
        echo -e "${RED}  ✗ Failed to load Chicago data${NC}"
        rm -f /tmp/load_chicago.sql
        return 1
    fi
}

# Function to load LA data
load_la() {
    echo -e "${BLUE}Loading Los Angeles crime data...${NC}"
    
    # LA has two files that need to be combined
    local file1="/data/crime_data/raw/la_old.csv"
    local file2="/data/crime_data/raw/la_new.csv"
    
    # Load first LA file
    if [ -f "$file1" ]; then
        echo -e "${WHITE}  Loading LA historical data...${NC}"
        
        cat > /tmp/load_la.sql << 'SQLEOF'
SET SESSION sql_mode = '';
SET SESSION foreign_key_checks = 0;

TRUNCATE TABLE la_crimes;

LOAD DATA LOCAL INFILE '/data/crime_data/raw/la_old.csv'
INTO TABLE la_crimes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    dr_no, @date_rptd, @date_occ, @time_occ, @area, area_name, 
    rpt_dist_no, @part_1_2, @crm_cd, crm_cd_desc, mocodes,
    @vict_age, vict_sex, vict_descent, @premis_cd, premis_desc,
    @weapon_used_cd, weapon_desc, status, status_desc,
    @crm_cd_1, @crm_cd_2, @crm_cd_3, @crm_cd_4,
    location, cross_street, @lat, @lon
)
SET
    date_rptd = STR_TO_DATE(@date_rptd, '%m/%d/%Y %h:%i:%s %p'),
    date_occ = STR_TO_DATE(@date_occ, '%m/%d/%Y %h:%i:%s %p'),
    time_occ = LPAD(@time_occ, 4, '0'),
    area = NULLIF(@area, ''),
    part_1_2 = NULLIF(@part_1_2, ''),
    crm_cd = NULLIF(@crm_cd, ''),
    vict_age = NULLIF(@vict_age, ''),
    premis_cd = NULLIF(@premis_cd, ''),
    weapon_used_cd = NULLIF(@weapon_used_cd, ''),
    crm_cd_1 = NULLIF(@crm_cd_1, ''),
    crm_cd_2 = NULLIF(@crm_cd_2, ''),
    crm_cd_3 = NULLIF(@crm_cd_3, ''),
    crm_cd_4 = NULLIF(@crm_cd_4, ''),
    lat = NULLIF(@lat, ''),
    lon = NULLIF(@lon, '');
SQLEOF

        mysql --local-infile=1 -u crime_analyst -p"$MYSQL_PASS" crime_data < /tmp/load_la.sql 2>/dev/null
        local count1=$(mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "SELECT COUNT(*) FROM la_crimes;" -s -N 2>/dev/null)
        echo -e "${GREEN}    ✓ Loaded $(printf "%'d" $count1) historical records${NC}"
    fi
    
    # Load second LA file (append)
    if [ -f "$file2" ]; then
        echo -e "${WHITE}  Loading LA recent data...${NC}"
        
        # Modify the SQL to INSERT instead of TRUNCATE
        sed 's/TRUNCATE TABLE la_crimes;//g' /tmp/load_la.sql | \
        sed "s|la_old.csv|la_new.csv|g" > /tmp/load_la2.sql
        
        mysql --local-infile=1 -u crime_analyst -p"$MYSQL_PASS" crime_data < /tmp/load_la2.sql 2>/dev/null
        local count2=$(mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "SELECT COUNT(*) FROM la_crimes;" -s -N 2>/dev/null)
        echo -e "${GREEN}    ✓ Total LA records: $(printf "%'d" $count2)${NC}"
        
        rm -f /tmp/load_la.sql /tmp/load_la2.sql
    fi
}

# Function to load Seattle data
load_seattle() {
    echo -e "${BLUE}Loading Seattle crime data...${NC}"
    local file="/data/crime_data/raw/seattle.csv"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Seattle data file not found${NC}"
        return 1
    fi
    
    cat > /tmp/load_seattle.sql << 'SQLEOF'
SET SESSION sql_mode = '';
SET SESSION foreign_key_checks = 0;

TRUNCATE TABLE seattle_crimes;

LOAD DATA LOCAL INFILE '/data/crime_data/raw/seattle.csv'
INTO TABLE seattle_crimes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    report_number, @offense_id, @offense_start_datetime, @offense_end_datetime,
    @report_datetime, group_a_b, crime_against_category, offense_parent_group,
    offense, offense_code, precinct, sector, beat, mcpp,
    _100_block_address, @longitude, @latitude
)
SET
    offense_id = NULLIF(@offense_id, ''),
    offense_start_datetime = STR_TO_DATE(@offense_start_datetime, '%m/%d/%Y %h:%i:%s %p'),
    offense_end_datetime = STR_TO_DATE(@offense_end_datetime, '%m/%d/%Y %h:%i:%s %p'),
    report_datetime = STR_TO_DATE(@report_datetime, '%m/%d/%Y %h:%i:%s %p'),
    longitude = NULLIF(@longitude, ''),
    latitude = NULLIF(@latitude, '');
SQLEOF

    mysql --local-infile=1 -u crime_analyst -p"$MYSQL_PASS" crime_data < /tmp/load_seattle.sql 2>/dev/null
    
    if [ $? -eq 0 ]; then
        local count=$(mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "SELECT COUNT(*) FROM seattle_crimes;" -s -N 2>/dev/null)
        echo -e "${GREEN}  ✓ Loaded $(printf "%'d" $count) Seattle records${NC}"
        rm -f /tmp/load_seattle.sql
        return 0
    else
        echo -e "${RED}  ✗ Failed to load Seattle data${NC}"
        rm -f /tmp/load_seattle.sql
        return 1
    fi
}

# Main loading process
echo -e "${WHITE}Starting data import process...${NC}"
echo -e "${YELLOW}Note: This may take 10-30 minutes depending on system performance${NC}"
echo ""

# Enable local infile for MySQL
mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "SET GLOBAL local_infile = 1;" 2>/dev/null

# Load each dataset
LOAD_SUCCESS=true

load_chicago || LOAD_SUCCESS=false
echo ""

load_la || LOAD_SUCCESS=false
echo ""

load_seattle || LOAD_SUCCESS=false
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$LOAD_SUCCESS" = true ]; then
    echo -e "${GREEN}🎉 DATA LOADING COMPLETE!${NC}"
    echo ""
    
    # Show final counts
    mysql -u crime_analyst -p"$MYSQL_PASS" crime_data -e "
    SELECT 
        'Chicago' as City,
        FORMAT(COUNT(*), 0) as Records,
        MIN(date) as Earliest,
        MAX(date) as Latest
    FROM chicago_crimes
    UNION ALL
    SELECT 
        'Los Angeles' as City,
        FORMAT(COUNT(*), 0) as Records,
        MIN(date_occ) as Earliest,
        MAX(date_occ) as Latest
    FROM la_crimes
    UNION ALL
    SELECT 
        'Seattle' as City,
        FORMAT(COUNT(*), 0) as Records,
        MIN(offense_start_datetime) as Earliest,
        MAX(offense_start_datetime) as Latest
    FROM seattle_crimes;" 2>/dev/null
    
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "${WHITE}1. Run 'mmp_status' to see database statistics${NC}"
    echo -e "${WHITE}2. Run 'mmp_db' to query the data${NC}"
    echo -e "${WHITE}3. Consider running the normalization script for unified analysis${NC}"
else
    echo -e "${RED}⚠️  Some datasets failed to load${NC}"
    echo -e "${YELLOW}Check the error messages above and try again${NC}"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOF
chmod +x /usr/local/bin/mmp_load
```

**Where to add it:** Replace the existing `mmp_load` creation block around lines 1030-1050 in the v08_corrected script (in the PART 3 section, after the other utility commands).

This implementation:
- ✅ Checks download completion
- ✅ Loads Chicago, LA, and Seattle CSV files
- ✅ Handles date/time format conversions
- ✅ Shows progress and record counts
- ✅ Provides error handling
- ✅ Combines both LA files (historical and recent)
- ✅ Shows summary statistics after loading

---
**UNKNOWN**

wjhat re the 5 lines before the insert and five lines after so i can delete the inbetween block

---
**UNKNOWN**


Looking at the v08_corrected script, here are the 5 lines before and after the `mmp_load` creation block:

**5 lines BEFORE:**
```bash
EOF
chmod +x /usr/local/bin/mmp_help

# Create mmp_load placeholder (to be implemented when downloads complete)
cat > /usr/local/bin/mmp_load << 'EOF'
```

**5 lines AFTER:**
```bash
EOF
chmod +x /usr/local/bin/mmp_load

# Install Python packages
echo -e "${WHITE}Installing Python packages...${NC}"
python3 -m pip install --user pandas mysql-connector-python tqdm &>/dev/null
```

So you need to delete everything between:
- `# Create mmp_load placeholder (to be implemented when downloads complete)`
- `chmod +x /usr/local/bin/mmp_load`

And replace it with the new `mmp_load` implementation I provided above.

---
**UNKNOWN**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 MONITORING COMMANDS:
  mmp_status      - Complete system dashboard with downloads
  mmp_check       - Check download completion status
  mmp_security    - Security configuration status
🗄️ DATABASE COMMANDS:
  mmp_db          - Direct database access
  mmp_unified     - Unified data analysis
  mmp_load        - Load data after downloads complete
🔐 SECURITY COMMANDS:
  mmp_decrypt     - Decrypt stored credentials
🆔 SYSTEM INFO:
  Installation ID: 98A90AC8
  Recovery: Use passphrase with mmp_decrypt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@two ~]# mmp_load
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📊 MMP DATA LOADING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All files downloaded. Starting data load...
❌ Cannot connect to database
[root@two ~]#

---
**UNKNOWN**


The issue is that `mmp_load` cannot retrieve the MySQL password. Let's debug this:

1. **First, check if the credentials file exists:**
```bash
ls -la /home/maverick/.mmp/mysql_creds.txt
```

2. **Check the content format:**
```bash
cat /home/maverick/.mmp/mysql_creds.txt
```

3. **Try to get the password manually:**
```bash
grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt
```

The issue is likely one of:
- The file doesn't exist
- The format doesn't match (might be "MySQL app" without colon)
- Running as root instead of maverick user

**Quick fix - Update the mmp_load script** to handle different formats:

```bash
# Edit mmp_load
nano /usr/local/bin/mmp_load
```

Find this line:
```bash
MYSQL_PASS=$(grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)
```

Replace with:
```bash
# Try multiple formats
MYSQL_PASS=$(grep -E "MySQL app:|MySQL app" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | awk -F'[: ]' '{print $NF}')

# If still empty, try to decrypt
if [ -z "$MYSQL_PASS" ]; then
    echo -e "${YELLOW}Attempting to retrieve credentials via mmp_decrypt...${NC}"
    MYSQL_PASS=$(echo "[Ocean47\$Mountain82@RT!]" | mmp_decrypt 2>/dev/null | grep "MySQL app" | awk '{print $NF}')
fi

# If still empty, prompt
if [ -z "$MYSQL_PASS" ]; then
    echo -e "${YELLOW}Enter MySQL crime_analyst password:${NC}"
    read -s MYSQL_PASS
    echo ""
fi
```

This will make it more robust by:
1. Trying different grep patterns
2. Attempting to decrypt if needed
3. Prompting for manual entry as last resort

---
