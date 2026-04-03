# Crime Database System Setup
**Date:** 2025-07-04  
**Messages:** 20  
**UUID:** ae77e151-697f-4870-b817-eb1e8f08aea0

---

**UNKNOWN**

injest: tell me when ready: ask clarifying wuestion

---
**UNKNOWN**

 I've read through the entire conversation and document. This is a fascinating and complex project involving a crime database system with multiple layers of security, data processing, and monitoring capabilities.

I'm ready to help! Here are my clarifying questions:

1. **Current Status**: Based on the conversation, it looks like you have:
   - Completed the v04/v05 installation script
   - Downloads are complete (~6GB of crime data)
   - Empty database tables (need to run `mmp_load`)
   - Ready to normalize data into unified tables
   
   Is this accurate? What's your immediate priority?

2. **Specific Task**: Are you looking to:
   - Fix the missing `mmp_load` command issue?
   - Run the unified normalization script?
   - Implement the enhanced monitoring system?
   - Something else entirely?

3. **SMS/Notification System**: I see references to SMS hooks and notification systems throughout. Do you want me to focus on:
   - The integration points for your external SMS system?
   - The notification file formats and APIs?
   - Error reporting mechanisms?

4. **Script Completion**: The conversation shows some scripts were partially completed. Do you need:
   - The complete v05 script with all sideload features?
   - The unified normalization script?
   - The monitoring system?
   - All of the above?

5. **Environment**: Are you working on:
   - The same Rocky Linux system from the conversation?
   - A new system that needs the full setup?
   - Testing/development environment?

What would you like me to tackle first?

---
**UNKNOWN**

v50 is mothballed until further notice. we are using v04 rifght now it seems to work. i have the databases doenload but not parsed then merged into a signle tabel here is teh sscrit that is consiereed our working version . here is the original version_beta/. What do i have to do now? This si the script you were wrokgn on when you ended. you were needing to make sure t checked fro running versions of itself and the main downloader. if a databse is downleaded while thers downloing then porcess the finsihed dbd andvcheck the sdpownloads when done to see if the other arfe done.

---
**UNKNOWN**



---
**UNKNOWN**



---
**UNKNOWN**

 Perfect! I understand the situation. You have v04 working well with downloads complete but need to:

1. **Create the missing `mmp_load` command** that processes downloaded data into MySQL
2. **Create an intelligent processor** that monitors downloads and processes completed files
3. **Add conflict detection** to prevent multiple instances running simultaneously
4. **Create the normalization/unified table system**

Let me create the complete solution:

## Step 1: Create the Missing `mmp_load` Command

```bash
nano /usr/local/bin/mmp_load
```

```bash
#!/bin/bash
# mmp_load - Intelligent Crime Data Loader with Process Management
# Enhanced with conflict detection and progressive processing

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
LOCK_FILE="/tmp/mmp_load.lock"
LOG_FILE="/tmp/mmp_load.log"
PROCESS_DIR="/tmp/mmp_processing"
INSTALLATION_ID=$(cat /root/mmp_logs/progress.txt 2>/dev/null | tail -1 | cut -d'|' -f4 || echo "UNKNOWN")

# Get MySQL credentials
get_mysql_credentials() {
    local mysql_pass=""

---
**UNKNOWN**



---
**UNKNOWN**

 Perfect! I can see you have the unified normalization script ready. Now I understand exactly what you need. Let me create the intelligent data processing system that will:

1. **Check for running instances** (prevent conflicts)
2. **Load data into the original city tables first** 
3. **Monitor downloads and process completed files**
4. **Run normalization after all data is loaded**

## Complete Solution: Intelligent MMP Data Processor

```bash
nano /usr/local/bin/mmp_load
```

```bash
#!/bin/bash
# mmp_load - Intelligent Crime Data Processor v04
# Enhanced with conflict detection, progressive processing, and normalization

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
LOCK_FILE="/tmp/mmp_load.lock"
DOWNLOAD_LOCK="/tmp/mmp_download.lock"
LOG_FILE="/tmp/mmp_load.log"
PROCESS_DIR="/tmp/mmp_processing"
INSTALLATION_ID=$(cat /root/mmp_logs/progress.txt 2>/dev/null | tail -1 | cut -d'|' -f4 || echo "UNKNOWN")

# Process tracking
declare -A CITY_STATUS
declare -A FILE_SIZES

# ============================================
# CONFLICT DETECTION AND PROCESS MANAGEMENT
# ============================================

check_running_instances() {
    echo -e "${BLUE}[CHECKING]: Looking for running instances...${NC}"
    
    # Check for existing lock files
    if [ -f "$LOCK_FILE" ]; then
        local lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
        if kill -0 "$lock_pid" 2>/dev/null; then
            echo -e "${YELLOW}⚠ mmp_load already running (PID: $lock_pid)${NC}"
            echo -e "${WHITE}Options:${NC}"
            echo -e "${WHITE}1. Wait for current process to complete${NC}"
            echo -e "${WHITE}2. Kill existing process and restart${NC}"
            echo -e "${WHITE}3. Exit and check manually${NC}"
            echo ""
            read -p "Choose option (1-3): " -n 1 -r
            echo ""
            
            case $REPLY in
                1)
                    echo -e "${BLUE}Waiting for existing process...${NC}"
                    wait_for_process "$lock_pid"
                    ;;
                2)
                    echo -e "${YELLOW}Killing existing process...${NC}"
                    kill -TERM "$lock_pid" 2>/dev/null
                    sleep 3
                    kill -KILL "$lock_pid" 2>/dev/null
                    rm -f "$LOCK_FILE"
                    ;;
                3)
                    echo -e "${WHITE}Exiting. Check processes with: ps aux | grep mmp${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}Invalid option${NC}"
                    exit 1
                    ;;
            esac
        else
            # Stale lock file
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # Check for download processes
    local download_processes=$(pgrep -f "download_crime_data\|wget.*csv" | wc -l)
    if [ "$download_processes" -gt 0 ]; then
        echo -e "${BLUE}⚡ Downloads still active ($download_processes processes)${NC}"
        echo -e "${WHITE}Will monitor and process files as they complete...${NC}"
        DOWNLOADS_ACTIVE=true
    else
        echo -e "${GREEN}✓ No active downloads detected${NC}"
        DOWNLOADS_ACTIVE=false
    fi
    
    # Create our lock
    echo $$ > "$LOCK_FILE"
    trap cleanup

---
**UNKNOWN**

and provoide upadtes in the exact color sheme ast this attached

---
**UNKNOWN**

 Perfect! I understand the color scheme and requirements. Let me create the complete intelligent `mmp_load` command that follows the v04 color scheme and handles all the conflict detection and progressive processing you need.

```bash
nano /usr/local/bin/mmp_load
```

```bash
#!/bin/bash
# mmp_load - Intelligent Crime Data Processor v04
# Enhanced with conflict detection, progressive processing, and normalization

# Colors - Matching v04 color scheme exactly
RED='\033[0;31m'        # CRITICAL SYSTEM HARM WARNING
ORANGE='\033[38;5;214m'  # HIGH ATTENTION WARNING  
GREEN='\033[0;32m'       # SUCCESS/GOOD
BLUE='\033[0;34m'        # INFORMATION/PROCESS
WHITE='\033[1;37m'       # NORMAL TEXT
NC='\033[0m'            # NO COLOR

# Configuration
LOCK_FILE="/tmp/mmp_load.lock"
DOWNLOAD_LOCK="/tmp/mmp_download.lock"
LOG_FILE="/tmp/mmp_load.log"
PROCESS_DIR="/tmp/mmp_processing"
INSTALLATION_ID=$(cat /root/mmp_logs/progress.txt 2>/dev/null | tail -1 | cut -d'|' -f4 || echo "UNKNOWN")

# Process tracking
declare -A CITY_STATUS
declare -A FILE_SIZES
DOWNLOADS_ACTIVE=false

# ============================================
# CONFLICT DETECTION AND PROCESS MANAGEMENT
# ============================================

cleanup() {
    echo -e "${BLUE}[CLEANUP]: Removing lock files and temporary data${NC}"
    rm -f "$LOCK_FILE" "$DOWNLOAD_LOCK" 2>/dev/null
    rm -rf "$PROCESS_DIR" 2>/dev/null
    exit 0
}

wait_for_process() {
    local pid="$1"
    local wait_time=0
    echo -e "${BLUE}[WAITING]: Monitoring process $pid...${NC}"
    
    while kill -0 "$pid" 2>/dev/null; do
        sleep 10
        wait_time=$((wait_time + 10))
        echo -e "${WHITE}Still waiting... ${wait_time}s elapsed${NC}"
        
        if [ $wait_time -gt 300 ]; then
            echo -e "${ORANGE}[WARNING]: Process taking longer than 5 minutes${NC}"
            echo -e "${WHITE}Continue waiting? (y/n):${NC}"
            read -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                break
            fi
        fi
    done
}

check_running_instances() {
    echo -e "${BLUE}[STEP 1/5 - ID: $INSTALLATION_ID]: Checking for running instances${NC}"
    
    # Check for existing mmp_load processes
    if [ -f "$LOCK_FILE" ]; then
        local lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
        if kill -0 "$lock_pid" 2>/dev/null; then
            echo -e "${ORANGE}[ERROR 1]: mmp_load already running (PID: $lock_pid)${NC}"
            echo -e "${WHITE}Options:${NC}"
            echo -e "${WHITE}1. Wait for current process to complete${NC}"
            echo -e "${WHITE}2. Kill existing process and restart${NC}"
            echo -e "${WHITE}3. Exit and check manually${NC}"
            echo ""
            read -p "Choose option (1-3): " -n 1 -r
            echo ""
            
            case $REPLY in
                1)
                    echo -e "${BLUE}[DOING NOW]: Waiting for existing process...${NC}"
                    wait_for_process "$lock_pid"
                    ;;
                2)
                    echo -e "${ORANGE}[DOING NOW]: Terminating existing process...${NC}"
                    kill -TERM "$lock_pid" 2>/dev/null
                    sleep 3
                    kill -KILL "$lock_pid" 2>/dev/null
                    rm -f "$LOCK_FILE"
                    echo -e "${GREEN}[SUCCESS]: Previous process terminated${NC}"
                    ;;
                3)
                    echo -e "${WHITE}Exiting. Check processes with: ps aux | grep mmp${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}[CRITICAL ERROR 1]: Invalid option${NC}"
                    exit 1
                    ;;
            esac
        else
            # Stale lock file
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # Check for download processes
    local download_processes=$(pgrep -f "download_crime_data\|wget.*csv" | wc -l)
    if [ "$download_processes" -gt 0 ]; then
        echo -e "${BLUE}⚡ Downloads still active ($download_processes processes)${NC}"
        echo -e "${WHITE}Will monitor and process files as they complete...${NC}"
        DOWNLOADS_ACTIVE=true
    else
        echo -e "${GREEN}✓ No active downloads detected${NC}"
        DOWNLOADS_ACTIVE=false
    fi
    
    # Create our lock and set cleanup trap
    echo $$ > "$LOCK_FILE"
    trap cleanup EXIT INT TERM
    
    echo -e "${GREEN}[SUCCESS]: Process checks completed${NC}"
}

# ============================================
# DATABASE CREDENTIAL MANAGEMENT
# ============================================

get_mysql_credentials() {
    echo -e "${BLUE}[STEP 2/5 - ID: $INSTALLATION_ID]: Retrieving database credentials${NC}"
    
    # Try to get from mmp_decrypt first
    local mysql_pass=""
    if command -v mmp_decrypt >/dev/null; then
        mysql_pass=$(echo "" | mmp_decrypt 2>/dev/null | grep "MySQL app" | cut -d'/' -f2 | xargs || echo "")
    fi
    
    # Fallback methods
    if [ -z "$mysql_pass" ]; then
        echo -e "${ORANGE}[WARNING]: Could not auto-retrieve MySQL password${NC}"
        echo -e "${WHITE}Enter MySQL crime_analyst password:${NC}"
        read -s mysql_pass
    fi
    
    # Test database connection
    echo -e "${WHITE}[DOING NOW]: Testing database connection...${NC}"
    if mysql -u crime_analyst -p"$mysql_pass" crime_data -e "SELECT 1;" &>/dev/null; then
        echo -e "${GREEN}[SUCCESS]: Database connection verified${NC}"
        echo "$mysql_pass"
    else
        echo -e "${RED}[CRITICAL ERROR 2]: Cannot connect to database${NC}"
        echo -e "${RED}This could harm your system or compromise security!${NC}"
        exit 1
    fi
}

# ============================================
# FILE MONITORING AND STATUS TRACKING
# ============================================

check_file_completion() {
    local filepath="$1"
    local expected_min_size="$2"
    
    if [ ! -f "$filepath" ]; then
        return 1
    fi
    
    # Check if file is still growing
    local size1=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
    sleep 2
    local size2=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
    
    # File is complete if it's not growing and meets minimum size
    if [ "$size1" = "$size2" ] && [ "$size1" -gt "$expected_min_size" ]; then
        return 0
    else
        return 1
    fi
}

monitor_downloads() {
    echo -e "${BLUE}[STEP 3/5 - ID: $INSTALLATION_ID]: Monitoring download status${NC}"
    
    # Define expected files with minimum sizes (in bytes)
    declare -A expected_files=(
        ["chicago.csv"]="1000000000"     # ~1GB minimum
        ["la_old.csv"]="300000000"       # ~300MB minimum  
        ["la_new.csv"]="100000000"       # ~100MB minimum
        ["seattle.csv"]="2000000000"     # ~2GB minimum
    )
    
    echo -e "${WHITE}Checking file completion status:${NC}"
    
    local all_complete=true
    local ready_to_process=()
    
    for file in "${!expected_files[@]}"; do
        local filepath="/data/crime_data/raw/$file"
        local min_size="${expected_files[$file]}"
        
        if check_file_completion "$filepath" "$min_size"; then
            local size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
            echo -e "${GREEN}  $file: $size ✓ Ready${NC}"
            ready_to_process+=("$file")
            CITY_STATUS["$file"]="READY"
        elif [ -f "$filepath" ]; then
            local size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
            echo -e "${BLUE}  $file: $size ⚡ Downloading${NC}"
            CITY_STATUS["$file"]="DOWNLOADING"
            all_complete=false
        else
            echo -e "${ORANGE}  $file: Not found ✗${NC}"
            CITY_STATUS["$file"]="MISSING"
            all_complete=false
        fi
    done
    
    echo ""
    if [ ${#ready_to_process[@]} -gt 0 ]; then
        echo -e "${GREEN}Files ready for processing: ${#ready_to_process[@]}${NC}"
        echo "${ready_to_process[@]}"
    fi
    
    if [ "$all_complete" = true ]; then
        echo -e "${GREEN}[SUCCESS]: All downloads completed${NC}"
        DOWNLOADS_ACTIVE=false
    else
        echo -e "${BLUE}Downloads still in progress...${NC}"
        DOWNLOADS_ACTIVE=true
    fi
    
    echo "${ready_to_process[@]}"
}

# ============================================
# PYTHON DATA LOADING SYSTEM
# ============================================

install_python_dependencies() {
    echo -e "${BLUE}[DOING NOW]: Installing Python data packages${NC}"
    
    # Check if packages are already installed
    if python3 -c "import pandas, mysql.connector, tqdm" 2>/dev/null; then
        echo -e "${GREEN}✓ Python packages already installed${NC}"
        return 0
    fi
    
    echo -e "${WHITE}Installing: pandas, mysql-connector-python, tqdm${NC}"
    if python3 -m pip install --user pandas mysql-connector-python tqdm 2>/dev/null; then
        echo -e "${GREEN}[SUCCESS]: Python packages installed${NC}"
    else
        echo -e "${ORANGE}[WARNING]: Some Python packages may not have installed${NC}"
        echo -e "${WHITE}Continuing anyway...${NC}"
    fi
}

process_single_file() {
    local filename="$1"
    local mysql_pass="$2"
    
    echo -e "${BLUE}[DOING NOW]: Processing $filename${NC}"
    
    # Create Python loader script for this specific file
    cat > "/tmp/load_${filename%.csv}.py" << PYEOF
#!/usr/bin/env python3
import pandas as pd
import mysql.connector
from datetime import datetime
import os
import sys
import time
import warnings
warnings.filterwarnings('ignore')

print(f"\\n=== MMP Data Loader for ${filename} ===")
print(f"Installation ID: $INSTALLATION_ID")
print(f"Timestamp: {datetime.now()}")
print()

# Database config
config = {
    'user': 'crime_analyst',
    'password': '$mysql_pass',
    'host': 'localhost',
    'database': 'crime_data',
    'autocommit': False
}

def show_progress(message, current=0, total=0):
    if total > 0:
        percent = (current / total) * 100
        print(f"\\r{message}: {current:,}/{total:,} ({percent:.1f}%)", end='', flush=True)
    else:
        print(f"\\r{message}...", end='', flush=True)

def clean_datetime(date_str):
    if pd.isna(date_str) or date_str == '':
        return None
    try:
        formats = [
            '%m/%d/%Y %I:%M:%S %p',
            '%Y-%m-%d %H:%M:%S',
            '%Y-%m-%dT%H:%M:%S.%f',
            '%Y-%m-%d',
            '%m/%d/%Y'
        ]
        date_str = str(date_str).strip()
        for fmt in formats:
            try:
                return datetime.strptime(date_str, fmt)
            except:
                continue
    except:
        pass
    return None

# Connect to database
print("Connecting to database...")
try:
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    print("✓ Connected successfully")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

file_path = "/data/crime_data/raw/${filename}"
if not os.path.exists(file_path):
    print(f"✗ File not found: {file_path}")
    sys.exit(1)

file_size = os.path.getsize(file_path) / (1024**3)
print(f"File: {file_path}")
print(f"Size: {file_size:.2f} GB")

chunk_size = 50000
total_loaded = 0
start_time = time.time()

try:
    # Determine table and processing based on filename
    if "chicago" in "${filename}":
        table_name = "chicago_crimes"
        cursor.execute("ALTER TABLE chicago_crimes DISABLE KEYS")
        
        for chunk_num, chunk in enumerate(pd.read_csv(file_path, chunksize=chunk_size, low_memory=False)):
            # Clean Chicago data
            if 'Date' in chunk.columns:
                chunk['Date'] = chunk['Date'].apply(clean_datetime)
            if 'Updated On' in chunk.columns:
                chunk['Updated On'] = chunk['Updated On'].apply(clean_datetime)
            if 'Arrest' in chunk.columns:
                chunk['Arrest'] = chunk['Arrest'].map({'true': 1, 'false': 0, True: 1, False: 0}).fillna(0)
            if 'Domestic' in chunk.columns:
                chunk['Domestic'] = chunk['Domestic'].map({'true': 1, 'false': 0, True: 1, False: 0}).fillna(0)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('Case Number'), row.get('Date'), row.get('Block'),
                    row.get('IUCR'), row.get('Primary Type'), row.get('Description'),
                    row.get('Location Description'), row.get('Arrest'), row.get('Domestic'),
                    row.get('Beat'), row.get('District'), row.get('Ward'),
                    row.get('Community Area'), row.get('FBI Code'), row.get('X Coordinate'),
                    row.get('Y Coordinate'), row.get('Year'), row.get('Updated On'),
                    row.get('Latitude'), row.get('Longitude'), row.get('Location')
                ))
            
            # Insert data
            insert_query = """
            INSERT IGNORE INTO chicago_crimes (
                case_number, date, block, iucr, primary_type, description,
                location_description, arrest, domestic, beat, district, ward,
                community_area, fbi_code, x_coordinate, y_coordinate, year,
                updated_on, latitude, longitude, location
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress("Processing Chicago", total_loaded)
        
        cursor.execute("ALTER TABLE chicago_crimes ENABLE KEYS")
        
    elif "la_" in "${filename}":
        table_name = "la_crimes"
        if total_loaded == 0:  # Only disable keys on first LA file
            cursor.execute("ALTER TABLE la_crimes DISABLE KEYS")
        
        for chunk in pd.read_csv(file_path, chunksize=chunk_size, low_memory=False):
            # Clean dates
            if 'Date Rptd' in chunk.columns:
                chunk['Date Rptd'] = chunk['Date Rptd'].apply(clean_datetime)
            if 'DATE OCC' in chunk.columns:
                chunk['DATE OCC'] = chunk['DATE OCC'].apply(clean_datetime)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('DR_NO'), row.get('Date Rptd'), row.get('DATE OCC'),
                    row.get('TIME OCC'), row.get('AREA'), row.get('AREA NAME'),
                    row.get('Rpt Dist No'), row.get('Part 1-2'), row.get('Crm Cd'),
                    row.get('Crm Cd Desc'), row.get('Mocodes'), row.get('Vict Age'),
                    row.get('Vict Sex'), row.get('Vict Descent'), row.get('Premis Cd'),
                    row.get('Premis Desc'), row.get('Weapon Used Cd'), row.get('Weapon Desc'),
                    row.get('Status'), row.get('Status Desc'), row.get('Crm Cd 1'),
                    row.get('Crm Cd 2'), row.get('Crm Cd 3'), row.get('Crm Cd 4'),
                    row.get('LOCATION'), row.get('Cross Street'), row.get('LAT'), row.get('LON')
                ))
            
            insert_query = """
            INSERT IGNORE INTO la_crimes (
                dr_no, date_rptd, date_occ, time_occ, area, area_name,
                rpt_dist_no, part_1_2, crm_cd, crm_cd_desc, mocodes,
                vict_age, vict_sex, vict_descent, premis_cd, premis_desc,
                weapon_used_cd, weapon_desc, status, status_desc,
                crm_cd_1, crm_cd_2, crm_cd_3, crm_cd_4, location,
                cross_street, lat, lon
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress(f"Processing LA ({os.path.basename(file_path)})", total_loaded)
        
        # Only enable keys after all LA files are processed
        # cursor.execute("ALTER TABLE la_crimes ENABLE KEYS")
        
    elif "seattle" in "${filename}":
        table_name = "seattle_crimes"
        cursor.execute("ALTER TABLE seattle_crimes DISABLE KEYS")
        
        for chunk in pd.read_csv(file_path, chunksize=chunk_size, low_memory=False):
            # Clean Seattle data
            date_cols = ['Offense Start DateTime', 'Offense End DateTime', 'Report DateTime']
            for col in date_cols:
                if col in chunk.columns:
                    chunk[col] = chunk[col].apply(clean_datetime)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('Report Number'), row.get('Offense ID'),
                    row.get('Offense Start DateTime'), row.get('Offense End DateTime'),
                    row.get('Report DateTime'), row.get('NIBRS Group AB'),
                    row.get('NIBRS Crime Against Category'), row.get('Offense Category'),
                    row.get('Offense Sub Category'), row.get('Offense Code'),
                    row.get('Precinct'), row.get('Sector'), row.get('Beat'),
                    row.get('MCPP'), row.get('100 Block Address'),
                    row.get('Longitude'), row.get('Latitude')
                ))
            
            insert_query = """
            INSERT IGNORE INTO seattle_crimes (
                report_number, offense_id, offense_start_datetime, offense_end_datetime,
                report_datetime, group_a_b, crime_against_category, offense_parent_group,
                offense, offense_code, precinct, sector, beat, mcpp,
                _100_block_address, longitude, latitude
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress("Processing Seattle", total_loaded)
        
        cursor.execute("ALTER TABLE seattle_crimes ENABLE KEYS")
        
    elapsed = time.time() - start_time
    print(f"\\n✓ {os.path.basename(file_path)} complete: {total_loaded:,} records in {elapsed:.1f} seconds")
    
    # Mark as processed
    with open("/tmp/mmp_processed_${filename%.csv}.flag", "w") as f:
        f.write(f"{total_loaded}\\n{elapsed:.1f}\\n{datetime.now()}\\n")
    
except Exception as e:
    print(f"\\n✗ Error processing ${filename}: {e}")
    conn.rollback()
    sys.exit(1)

cursor.close()
conn.close()
print(f"Database connection closed for ${filename}")

PYEOF

    # Execute the Python script
    if python3 "/tmp/load_${filename%.csv}.py"; then
        echo -e "${GREEN}[SUCCESS]: $filename processed successfully${NC}"
        CITY_STATUS["$filename"]="PROCESSED"
        return 0
    else
        echo -e "${ORANGE}[ERROR]: Failed to process $filename${NC}"
        CITY_STATUS["$filename"]="FAILED"
        return 1
    fi
}

# ============================================
# MAIN PROCESSING ORCHESTRATOR
# ============================================

process_ready_files() {
    local mysql_pass="$1"
    local ready_files=("${@:2}")
    
    echo -e "${BLUE}[STEP 4/5 - ID: $INSTALLATION_ID]: Processing ready files${NC}"
    
    if [ ${#ready_files[@]} -eq 0 ]; then
        echo -e "${ORANGE}[WARNING]: No files ready for processing${NC}"
        return 0
    fi
    
    install_python_dependencies
    
    local processed_count=0
    local failed_count=0
    
    for file in "${ready_files[@]}"; do
        echo ""
        echo -e "${WHITE}=============================================${NC}"
        echo -e "${BLUE}Processing: $file${NC}"
        echo -e "${WHITE}=============================================${NC}"
        
        if process_single_file "$file" "$mysql_pass"; then
            processed_count=$((processed_count + 1))
            
            # Special handling for LA files - enable keys after both are done
            if [[ "$file" == "la_"* ]]; then
                local other_la_file=""
                if [[ "$file" == "la_old.csv" ]]; then
                    other_la_file="la_new.csv"
                else
                    other_la_file="la_old.csv"
                fi
                
                if [ -f "/tmp/mmp_processed_${other_la_file%.csv}.flag" ]; then
                    echo -e "${BLUE}[DOING NOW]: Enabling LA crimes table keys${NC}"
                    mysql -u crime_analyst -p"$mysql_pass" crime_data -e "ALTER TABLE la_crimes ENABLE KEYS;" 2>/dev/null
                    echo -e "${GREEN}[SUCCESS]: LA crimes table optimized${NC}"
                fi
            fi
        else
            failed_count=$((failed_count + 1))
        fi
    done
    
    echo ""
    echo -e "${WHITE}Processing Summary:${NC}"
    echo -e "${GREEN}Successful: $processed_count${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "${ORANGE}Failed: $failed_count${NC}"
    fi
    
    # Clean up temporary Python scripts
    rm -f /tmp/load_*.py 2>/dev/null
}

# ============================================
# PROGRESSIVE MONITORING LOOP
# ============================================

progressive_monitor() {
    local mysql_pass="$1"
    
    echo -e "${BLUE}[DOING NOW]: Starting progressive monitoring${NC}"
    echo -e "${WHITE}Will check every 30 seconds for completed downloads${NC}"
    echo ""
    
    local monitor_count=0
    
    while [ "$DOWNLOADS_ACTIVE" = true ]; do
        monitor_count=$((monitor_count + 1))
        
        echo -e "${BLUE}Monitor cycle $monitor_count - $(date)${NC}"
        
        # Check for newly completed files
        local ready_files=($(monitor_downloads))
        
        # Process any ready files that haven't been processed yet
        local new_ready=()
        for file in "${ready_files[@]}"; do
            if [ ! -f "/tmp/mmp_processed_${file%.csv}.flag" ]; then
                new_ready+=("$file")
            fi
        done
        
        if [ ${#new_ready[@]} -gt 0 ]; then
            echo -e "${GREEN}Found ${#new_ready[@]} new completed file(s)${NC}"
            process_ready_files "$mysql_pass" "${new_ready[@]}"
        else
            echo -e "${WHITE}No new files ready for processing${NC}"
        fi
        
        # Check if downloads are still active
        local active_downloads=$(pgrep -f "wget.*csv" | wc -l)
        if [ "$active_downloads" -eq 0 ]; then
            echo -e "${GREEN}[SUCCESS]: All downloads completed${NC}"
            DOWNLOADS_ACTIVE=false
        else
            echo -e "${BLUE}Still $active_downloads active download(s)${NC}"
            echo -e "${WHITE}Waiting 30 seconds before next check...${NC}"
            sleep 30
        fi
        
        echo ""
    done
}

# ============================================
# NORMALIZATION TRIGGER
# ============================================

run_normalization() {
    echo -e "${BLUE}[STEP 5/5 - ID: $INSTALLATION_ID]: Running normalization${NC}"
    
    # Check if unified_crime_normalizer.sh exists
    if [ -f "/root/unified_crime_normalizer.sh" ]; then
        echo -e "${WHITE}[DOING NOW]: Running unified crime normalizer${NC}"
        if /root/unified_crime_normalizer.sh; then
            echo -e "${GREEN}[SUCCESS]: Normalization completed${NC}"
        else
            echo -e "${ORANGE}[WARNING]: Normalization encountered issues${NC}"
            echo -e "${WHITE}You can run it manually later: /root/unified_crime_normalizer.sh${NC}"
        fi
    else
        echo -e "${ORANGE}[WARNING]: Normalization script not found${NC}"
        echo -e "${WHITE}Skipping normalization step${NC}"
    fi
}

# ============================================
# MAIN EXECUTION
# ============================================

clear
echo -e "${WHITE}=============================================${NC}"
echo -e "${BLUE}   MMP CRIME DATA INTELLIGENT LOADER${NC}"
echo -e "${BLUE}   [Installation ID: $INSTALLATION_ID]${NC}"
echo -e "${WHITE}=============================================${NC}"
echo ""
echo -e "${GREEN}This intelligent loader will:${NC}"
echo -e "${WHITE}• Check for running processes and conflicts${NC}"
echo -e "${WHITE}• Monitor downloads and process completed files${NC}"
echo -e "${WHITE}• Load data into city-specific tables first${NC}"
echo -e "${WHITE}• Run normalization after all data is loaded${NC}"
echo -e "${WHITE}• Handle interruptions gracefully${NC}"
echo ""
echo -e "${WHITE}Press Ctrl+C to cancel, or wait 5 seconds to continue...${NC}"
sleep 5

# Execute main workflow
check_running_instances

MYSQL_PASS=$(get_mysql_credentials)

# Get initial file status
ready_files=($(monitor_downloads))

# Process any immediately ready files
if [ ${#ready_files[@]} -gt 0 ]; then
    process_ready_files "$MYSQL_PASS" "${ready_files[@]}"
fi

# If downloads are still active, start progressive monitoring
if [ "$DOWNLOADS_ACTIVE" = true ]; then
    progressive_monitor "$MYSQL_PASS"
fi

# Final check and processing
echo -e "${BLUE}[DOING NOW]: Final processing check${NC}"
ready_files=($(monitor_downloads))
new_ready=()
for file in "${ready_files[@]}"; do
    if [ ! -f "/tmp/mmp_processed_${file%.csv}.flag" ]; then
        new_ready+=("$file")
    fi
done

if [ ${#new_ready[@]} -gt 0 ]; then
    process_ready_files "$MYSQL_PASS" "${new_ready[@]}"
fi

# Run normalization if all files are processed
local total_processed=$(ls /tmp/mmp_processed_*.flag 2>/dev/null | wc -l)
if [ "$total_processed" -ge 3 ]; then  # Expecting at least chicago, seattle, and one LA file
    run_normalization
else
    echo -e "${ORANGE}[WARNING]: Not all files processed, skipping normalization${NC}"
    echo -e "${WHITE}You can run normalization manually later${NC}"
fi

echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  INTELLIGENT LOADING COMPLETE!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "${WHITE}Summary:${NC}"
echo -e "${GREEN}✓ Conflict detection and process management${NC}"
echo -e "${GREEN}✓ Progressive file monitoring and processing${NC}"
echo -e "${GREEN}✓ City-specific table population${NC}"
if [ "$total_processed" -ge 3 ]; then
    echo -e "${GREEN}✓ Unified table normalization${NC}"
fi
echo ""
echo -e "${BLUE}Next: Run 'mmp_status' to verify all data${NC}"
echo -e "${BLUE}      Use 'mmp_unified stats' for unified data analysis${NC}"
echo -e "${WHITE}=============================================${NC}"

# Cleanup happens automatically via trap
```

Now make it executable:

```bash
chmod +x /usr/local/bin/mmp_load
```

## Key Features of this Intelligent Loader:

✅ **Conflict Detection**: Checks for running `mmp_load` and download processes
✅ **Progressive Processing**: Processes files as they complete downloading
✅ **Color Scheme**: Matches your v04 script exactly (RED, ORANGE, GREEN, BLUE, WHITE)
✅ **Installation ID Integration**: Uses the same ID system throughout
✅ **Graceful Recovery**: Handles interruptions and can resume
✅ **Process Management**: Can wait for or terminate conflicting processes
✅ **File Monitoring**: Checks file completion with size validation
✅ **Sequential Processing**: Loads city tables first, then runs normalization
✅ **Error Handling**: Comprehensive error reporting with appropriate color coding

## Usage:

```bash
# Run after downloads are complete or while still downloading
mmp_load

# The system will automatically:
# 1. Check for conflicts
# 2. Process any ready files immediately  
# 3. Monitor ongoing downloads
# 4. Process files as they complete
# 5. Run normalization when all done
```

This gives you exactly what you need: intelligent processing that works whether downloads are complete or still running, with proper conflict detection and the exact v04 color scheme!

---
**UNKNOWN**

wait arent we eunnign this with the user asfter installation? so it shoudl be for the user maverick

---
**UNKNOWN**

 Absolutely right! The script needs to run as the `maverick` user after installation, not as root. Let me fix the paths and permissions to work properly for the maverick user.

```bash
nano /usr/local/bin/mmp_load
```

```bash
#!/bin/bash
# mmp_load - Intelligent Crime Data Processor v04
# Enhanced with conflict detection, progressive processing, and normalization
# Designed to run as maverick user after v04 installation

# Colors - Matching v04 color scheme exactly
RED='\033[0;31m'        # CRITICAL SYSTEM HARM WARNING
ORANGE='\033[38;5;214m'  # HIGH ATTENTION WARNING  
GREEN='\033[0;32m'       # SUCCESS/GOOD
BLUE='\033[0;34m'        # INFORMATION/PROCESS
WHITE='\033[1;37m'       # NORMAL TEXT
NC='\033[0m'            # NO COLOR

# Configuration for maverick user
LOCK_FILE="/tmp/mmp_load_$(whoami).lock"
DOWNLOAD_LOCK="/tmp/mmp_download_$(whoami).lock"
LOG_FILE="/home/maverick/.mmp/mmp_load.log"
PROCESS_DIR="/tmp/mmp_processing_$(whoami)"
INSTALLATION_ID=$(cat /root/mmp_logs/progress.txt 2>/dev/null | tail -1 | cut -d'|' -f4 || echo "UNKNOWN")

# Process tracking
declare -A CITY_STATUS
declare -A FILE_SIZES
DOWNLOADS_ACTIVE=false

# ============================================
# USER VERIFICATION AND SETUP
# ============================================

verify_user_setup() {
    echo -e "${BLUE}[VERIFICATION]: Checking user setup for data loading${NC}"
    
    # Check if running as maverick or root (for sudo)
    if [ "$(whoami)" != "maverick" ] && [ "$(whoami)" != "root" ]; then
        echo -e "${RED}[CRITICAL ERROR]: This script must be run as maverick user${NC}"
        echo -e "${WHITE}Switch to maverick: su - maverick${NC}"
        exit 1
    fi
    
    # Check if maverick home directory exists
    if [ ! -d "/home/maverick" ]; then
        echo -e "${RED}[CRITICAL ERROR]: Maverick user not properly set up${NC}"
        exit 1
    fi
    
    # Create log directory if it doesn't exist
    mkdir -p "/home/maverick/.mmp" 2>/dev/null
    chmod 700 "/home/maverick/.mmp" 2>/dev/null
    
    # Check data directory
    if [ ! -d "/data/crime_data/raw" ]; then
        echo -e "${RED}[CRITICAL ERROR]: Data directory not found${NC}"
        echo -e "${WHITE}Expected: /data/crime_data/raw${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[SUCCESS]: User setup verified${NC}"
}

# ============================================
# CONFLICT DETECTION AND PROCESS MANAGEMENT
# ============================================

cleanup() {
    echo -e "${BLUE}[CLEANUP]: Removing lock files and temporary data${NC}"
    rm -f "$LOCK_FILE" "$DOWNLOAD_LOCK" 2>/dev/null
    rm -rf "$PROCESS_DIR" 2>/dev/null
    exit 0
}

wait_for_process() {
    local pid="$1"
    local wait_time=0
    echo -e "${BLUE}[WAITING]: Monitoring process $pid...${NC}"
    
    while kill -0 "$pid" 2>/dev/null; do
        sleep 10
        wait_time=$((wait_time + 10))
        echo -e "${WHITE}Still waiting... ${wait_time}s elapsed${NC}"
        
        if [ $wait_time -gt 300 ]; then
            echo -e "${ORANGE}[WARNING]: Process taking longer than 5 minutes${NC}"
            echo -e "${WHITE}Continue waiting? (y/n):${NC}"
            read -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                break
            fi
        fi
    done
}

check_running_instances() {
    echo -e "${BLUE}[STEP 1/5 - ID: $INSTALLATION_ID]: Checking for running instances${NC}"
    
    # Check for existing mmp_load processes for this user
    if [ -f "$LOCK_FILE" ]; then
        local lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
        if kill -0 "$lock_pid" 2>/dev/null; then
            echo -e "${ORANGE}[ERROR 1]: mmp_load already running for $(whoami) (PID: $lock_pid)${NC}"
            echo -e "${WHITE}Options:${NC}"
            echo -e "${WHITE}1. Wait for current process to complete${NC}"
            echo -e "${WHITE}2. Kill existing process and restart${NC}"
            echo -e "${WHITE}3. Exit and check manually${NC}"
            echo ""
            read -p "Choose option (1-3): " -n 1 -r
            echo ""
            
            case $REPLY in
                1)
                    echo -e "${BLUE}[DOING NOW]: Waiting for existing process...${NC}"
                    wait_for_process "$lock_pid"
                    ;;
                2)
                    echo -e "${ORANGE}[DOING NOW]: Terminating existing process...${NC}"
                    kill -TERM "$lock_pid" 2>/dev/null
                    sleep 3
                    kill -KILL "$lock_pid" 2>/dev/null
                    rm -f "$LOCK_FILE"
                    echo -e "${GREEN}[SUCCESS]: Previous process terminated${NC}"
                    ;;
                3)
                    echo -e "${WHITE}Exiting. Check processes with: ps aux | grep mmp${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}[CRITICAL ERROR 1]: Invalid option${NC}"
                    exit 1
                    ;;
            esac
        else
            # Stale lock file
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # Check for download processes (look for maverick's processes)
    local download_processes=$(pgrep -u $(whoami) -f "download_crime_data\|wget.*csv" | wc -l)
    if [ "$download_processes" -gt 0 ]; then
        echo -e "${BLUE}⚡ Downloads still active ($download_processes processes)${NC}"
        echo -e "${WHITE}Will monitor and process files as they complete...${NC}"
        DOWNLOADS_ACTIVE=true
    else
        echo -e "${GREEN}✓ No active downloads detected${NC}"
        DOWNLOADS_ACTIVE=false
    fi
    
    # Create our lock and set cleanup trap
    echo $$ > "$LOCK_FILE"
    trap cleanup EXIT INT TERM
    
    echo -e "${GREEN}[SUCCESS]: Process checks completed${NC}"
}

# ============================================
# DATABASE CREDENTIAL MANAGEMENT
# ============================================

get_mysql_credentials() {
    echo -e "${BLUE}[STEP 2/5 - ID: $INSTALLATION_ID]: Retrieving database credentials${NC}"
    
    # Try to get from mmp_decrypt first
    local mysql_pass=""
    if command -v mmp_decrypt >/dev/null; then
        mysql_pass=$(echo "" | mmp_decrypt 2>/dev/null | grep "MySQL app" | cut -d'/' -f2 | xargs || echo "")
    fi
    
    # Fallback methods
    if [ -z "$mysql_pass" ]; then
        echo -e "${ORANGE}[WARNING]: Could not auto-retrieve MySQL password${NC}"
        echo -e "${WHITE}Enter MySQL crime_analyst password:${NC}"
        read -s mysql_pass
    fi
    
    # Test database connection
    echo -e "${WHITE}[DOING NOW]: Testing database connection...${NC}"
    if mysql -u crime_analyst -p"$mysql_pass" crime_data -e "SELECT 1;" &>/dev/null; then
        echo -e "${GREEN}[SUCCESS]: Database connection verified${NC}"
        echo "$mysql_pass"
    else
        echo -e "${RED}[CRITICAL ERROR 2]: Cannot connect to database${NC}"
        echo -e "${RED}This could harm your system or compromise security!${NC}"
        exit 1
    fi
}

# ============================================
# FILE MONITORING AND STATUS TRACKING
# ============================================

check_file_completion() {
    local filepath="$1"
    local expected_min_size="$2"
    
    if [ ! -f "$filepath" ]; then
        return 1
    fi
    
    # Check if file is still growing
    local size1=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
    sleep 2
    local size2=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
    
    # File is complete if it's not growing and meets minimum size
    if [ "$size1" = "$size2" ] && [ "$size1" -gt "$expected_min_size" ]; then
        return 0
    else
        return 1
    fi
}

monitor_downloads() {
    echo -e "${BLUE}[STEP 3/5 - ID: $INSTALLATION_ID]: Monitoring download status${NC}"
    
    # Define expected files with minimum sizes (in bytes)
    declare -A expected_files=(
        ["chicago.csv"]="1000000000"     # ~1GB minimum
        ["la_old.csv"]="300000000"       # ~300MB minimum  
        ["la_new.csv"]="100000000"       # ~100MB minimum
        ["seattle.csv"]="2000000000"     # ~2GB minimum
    )
    
    echo -e "${WHITE}Checking file completion status:${NC}"
    
    local all_complete=true
    local ready_to_process=()
    
    for file in "${!expected_files[@]}"; do
        local filepath="/data/crime_data/raw/$file"
        local min_size="${expected_files[$file]}"
        
        if check_file_completion "$filepath" "$min_size"; then
            local size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
            echo -e "${GREEN}  $file: $size ✓ Ready${NC}"
            ready_to_process+=("$file")
            CITY_STATUS["$file"]="READY"
        elif [ -f "$filepath" ]; then
            local size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
            echo -e "${BLUE}  $file: $size ⚡ Downloading${NC}"
            CITY_STATUS["$file"]="DOWNLOADING"
            all_complete=false
        else
            echo -e "${ORANGE}  $file: Not found ✗${NC}"
            CITY_STATUS["$file"]="MISSING"
            all_complete=false
        fi
    done
    
    echo ""
    if [ ${#ready_to_process[@]} -gt 0 ]; then
        echo -e "${GREEN}Files ready for processing: ${#ready_to_process[@]}${NC}"
        echo "${ready_to_process[@]}"
    fi
    
    if [ "$all_complete" = true ]; then
        echo -e "${GREEN}[SUCCESS]: All downloads completed${NC}"
        DOWNLOADS_ACTIVE=false
    else
        echo -e "${BLUE}Downloads still in progress...${NC}"
        DOWNLOADS_ACTIVE=true
    fi
    
    echo "${ready_to_process[@]}"
}

# ============================================
# PYTHON DATA LOADING SYSTEM
# ============================================

install_python_dependencies() {
    echo -e "${BLUE}[DOING NOW]: Installing Python data packages${NC}"
    
    # Check if packages are already installed
    if python3 -c "import pandas, mysql.connector, tqdm" 2>/dev/null; then
        echo -e "${GREEN}✓ Python packages already installed${NC}"
        return 0
    fi
    
    echo -e "${WHITE}Installing: pandas, mysql-connector-python, tqdm${NC}"
    if python3 -m pip install --user pandas mysql-connector-python tqdm 2>/dev/null; then
        echo -e "${GREEN}[SUCCESS]: Python packages installed${NC}"
    else
        echo -e "${ORANGE}[WARNING]: Some Python packages may not have installed${NC}"
        echo -e "${WHITE}Continuing anyway...${NC}"
    fi
}

process_single_file() {
    local filename="$1"
    local mysql_pass="$2"
    
    echo -e "${BLUE}[DOING NOW]: Processing $filename${NC}"
    
    # Create Python loader script for this specific file in maverick's temp space
    local temp_script="/home/maverick/.mmp/load_${filename%.csv}.py"
    
    cat > "$temp_script" << PYEOF
#!/usr/bin/env python3
import pandas as pd
import mysql.connector
from datetime import datetime
import os
import sys
import time
import warnings
warnings.filterwarnings('ignore')

print(f"\\n=== MMP Data Loader for ${filename} ===")
print(f"Installation ID: $INSTALLATION_ID")
print(f"Timestamp: {datetime.now()}")
print(f"User: $(whoami)")
print()

# Database config
config = {
    'user': 'crime_analyst',
    'password': '$mysql_pass',
    'host': 'localhost',
    'database': 'crime_data',
    'autocommit': False
}

def show_progress(message, current=0, total=0):
    if total > 0:
        percent = (current / total) * 100
        print(f"\\r{message}: {current:,}/{total:,} ({percent:.1f}%)", end='', flush=True)
    else:
        print(f"\\r{message}...", end='', flush=True)

def clean_datetime(date_str):
    if pd.isna(date_str) or date_str == '':
        return None
    try:
        formats = [
            '%m/%d/%Y %I:%M:%S %p',
            '%Y-%m-%d %H:%M:%S',
            '%Y-%m-%dT%H:%M:%S.%f',
            '%Y-%m-%d',
            '%m/%d/%Y'
        ]
        date_str = str(date_str).strip()
        for fmt in formats:
            try:
                return datetime.strptime(date_str, fmt)
            except:
                continue
    except:
        pass
    return None

# Connect to database
print("Connecting to database...")
try:
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    print("✓ Connected successfully")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

file_path = "/data/crime_data/raw/${filename}"
if not os.path.exists(file_path):
    print(f"✗ File not found: {file_path}")
    sys.exit(1)

file_size = os.path.getsize(file_path) / (1024**3)
print(f"File: {file_path}")
print(f"Size: {file_size:.2f} GB")

chunk_size = 50000
total_loaded = 0
start_time = time.time()

try:
    # Determine table and processing based on filename
    if "chicago" in "${filename}":
        table_name = "chicago_crimes"
        cursor.execute("ALTER TABLE chicago_crimes DISABLE KEYS")
        
        for chunk_num, chunk in enumerate(pd.read_csv(file_path, chunksize=chunk_size, low_memory=False)):
            # Clean Chicago data
            if 'Date' in chunk.columns:
                chunk['Date'] = chunk['Date'].apply(clean_datetime)
            if 'Updated On' in chunk.columns:
                chunk['Updated On'] = chunk['Updated On'].apply(clean_datetime)
            if 'Arrest' in chunk.columns:
                chunk['Arrest'] = chunk['Arrest'].map({'true': 1, 'false': 0, True: 1, False: 0}).fillna(0)
            if 'Domestic' in chunk.columns:
                chunk['Domestic'] = chunk['Domestic'].map({'true': 1, 'false': 0, True: 1, False: 0}).fillna(0)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('Case Number'), row.get('Date'), row.get('Block'),
                    row.get('IUCR'), row.get('Primary Type'), row.get('Description'),
                    row.get('Location Description'), row.get('Arrest'), row.get('Domestic'),
                    row.get('Beat'), row.get('District'), row.get('Ward'),
                    row.get('Community Area'), row.get('FBI Code'), row.get('X Coordinate'),
                    row.get('Y Coordinate'), row.get('Year'), row.get('Updated On'),
                    row.get('Latitude'), row.get('Longitude'), row.get('Location')
                ))
            
            # Insert data
            insert_query = """
            INSERT IGNORE INTO chicago_crimes (
                case_number, date, block, iucr, primary_type, description,
                location_description, arrest, domestic, beat, district, ward,
                community_area, fbi_code, x_coordinate, y_coordinate, year,
                updated_on, latitude, longitude, location
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress("Processing Chicago", total_loaded)
        
        cursor.execute("ALTER TABLE chicago_crimes ENABLE KEYS")
        
    elif "la_" in "${filename}":
        table_name = "la_crimes"
        # Only disable keys once for LA files
        if not os.path.exists("/home/maverick/.mmp/la_keys_disabled.flag"):
            cursor.execute("ALTER TABLE la_crimes DISABLE KEYS")
            with open("/home/maverick/.mmp/la_keys_disabled.flag", "w") as f:
                f.write("disabled")
        
        for chunk in pd.read_csv(file_path, chunksize=chunk_size, low_memory=False):
            # Clean dates
            if 'Date Rptd' in chunk.columns:
                chunk['Date Rptd'] = chunk['Date Rptd'].apply(clean_datetime)
            if 'DATE OCC' in chunk.columns:
                chunk['DATE OCC'] = chunk['DATE OCC'].apply(clean_datetime)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('DR_NO'), row.get('Date Rptd'), row.get('DATE OCC'),
                    row.get('TIME OCC'), row.get('AREA'), row.get('AREA NAME'),
                    row.get('Rpt Dist No'), row.get('Part 1-2'), row.get('Crm Cd'),
                    row.get('Crm Cd Desc'), row.get('Mocodes'), row.get('Vict Age'),
                    row.get('Vict Sex'), row.get('Vict Descent'), row.get('Premis Cd'),
                    row.get('Premis Desc'), row.get('Weapon Used Cd'), row.get('Weapon Desc'),
                    row.get('Status'), row.get('Status Desc'), row.get('Crm Cd 1'),
                    row.get('Crm Cd 2'), row.get('Crm Cd 3'), row.get('Crm Cd 4'),
                    row.get('LOCATION'), row.get('Cross Street'), row.get('LAT'), row.get('LON')
                ))
            
            insert_query = """
            INSERT IGNORE INTO la_crimes (
                dr_no, date_rptd, date_occ, time_occ, area, area_name,
                rpt_dist_no, part_1_2, crm_cd, crm_cd_desc, mocodes,
                vict_age, vict_sex, vict_descent, premis_cd, premis_desc,
                weapon_used_cd, weapon_desc, status, status_desc,
                crm_cd_1, crm_cd_2, crm_cd_3, crm_cd_4, location,
                cross_street, lat, lon
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress(f"Processing LA ({os.path.basename(file_path)})", total_loaded)
        
    elif "seattle" in "${filename}":
        table_name = "seattle_crimes"
        cursor.execute("ALTER TABLE seattle_crimes DISABLE KEYS")
        
        for chunk in pd.read_csv(file_path, chunksize=chunk_size, low_memory=False):
            # Clean Seattle data
            date_cols = ['Offense Start DateTime', 'Offense End DateTime', 'Report DateTime']
            for col in date_cols:
                if col in chunk.columns:
                    chunk[col] = chunk[col].apply(clean_datetime)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('Report Number'), row.get('Offense ID'),
                    row.get('Offense Start DateTime'), row.get('Offense End DateTime'),
                    row.get('Report DateTime'), row.get('NIBRS Group AB'),
                    row.get('NIBRS Crime Against Category'), row.get('Offense Category'),
                    row.get('Offense Sub Category'), row.get('Offense Code'),
                    row.get('Precinct'), row.get('Sector'), row.get('Beat'),
                    row.get('MCPP'), row.get('100 Block Address'),
                    row.get('Longitude'), row.get('Latitude')
                ))
            
            insert_query = """
            INSERT IGNORE INTO seattle_crimes (
                report_number, offense_id, offense_start_datetime, offense_end_datetime,
                report_datetime, group_a_b, crime_against_category, offense_parent_group,
                offense, offense_code, precinct, sector, beat, mcpp,
                _100_block_address, longitude, latitude
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress("Processing Seattle", total_loaded)
        
        cursor.execute("ALTER TABLE seattle_crimes ENABLE KEYS")
        
    elapsed = time.time() - start_time
    print(f"\\n✓ {os.path.basename(file_path)} complete: {total_loaded:,} records in {elapsed:.1f} seconds")
    
    # Mark as processed in maverick's space
    with open("/home/maverick/.mmp/processed_${filename%.csv}.flag", "w") as f:
        f.write(f"{total_loaded}\\n{elapsed:.1f}\\n{datetime.now()}\\n")
    
except Exception as e:
    print(f"\\n✗ Error processing ${filename}: {e}")
    conn.rollback()
    sys.exit(1)

cursor.close()
conn.close()
print(f"Database connection closed for ${filename}")

PYEOF

    # Execute the Python script
    if python3 "$temp_script"; then
        echo -e "${GREEN}[SUCCESS]: $filename processed successfully${NC}"
        CITY_STATUS["$filename"]="PROCESSED"
        
        # Special handling for LA files - enable keys after both are done
        if [[ "$filename" == "la_"* ]]; then
            local other_la_file=""
            if [[ "$filename" == "la_old.csv" ]]; then
                other_la_file="la_new.csv"
            else
                other_la_file="la_old.csv"
            fi
            
            if [ -f "/home/maverick/.mmp/processed_${other_la_file%.csv}.flag" ]; then
                echo -e "${BLUE}[DOING NOW]: Enabling LA crimes table keys${NC}"
                mysql -u crime_analyst -p"$mysql_pass" crime_data -e "ALTER TABLE la_crimes ENABLE KEYS;" 2>/dev/null
                rm -f "/home/maverick/.mmp/la_keys_disabled.flag" 2>/dev/null
                echo -e "${GREEN}[SUCCESS]: LA crimes table optimized${NC}"
            fi
        fi
        
        # Clean up the temp script
        rm -f "$temp_script"
        return 0
    else
        echo -e "${ORANGE}[ERROR]: Failed to process $filename${NC}"
        CITY_STATUS["$filename"]="FAILED"
        rm -f "$temp_script"
        return 1
    fi
}

# ============================================
# MAIN PROCESSING ORCHESTRATOR
# ============================================

process_ready_files() {
    local mysql_pass="$1"
    local ready_files=("${@:2}")
    
    echo -e "${BLUE}[STEP 4/5 - ID: $INSTALLATION_ID]: Processing ready files${NC}"
    
    if [ ${#ready_files[@]} -eq 0 ]; then
        echo -e "${ORANGE}[WARNING]: No files ready for processing${NC}"
        return 0
    fi
    
    install_python_dependencies
    
    local processed_count=0
    local failed_count=0
    
    for file in "${ready_files[@]}"; do
        echo ""
        echo -e "${WHITE}=============================================${NC}"
        echo -e "${BLUE}Processing: $file${NC}"
        echo -e "${WHITE}=============================================${NC}"
        
        if process_single_file "$file" "$mysql_pass"; then
            processed_count=$((processed_count + 1))
        else
            failed_count=$((failed_count + 1))
        fi
    done
    
    echo ""
    echo -e "${WHITE}Processing Summary:${NC}"
    echo -e "${GREEN}Successful: $processed_count${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "${ORANGE}Failed: $failed_count${NC}"
    fi
}

# ============================================
# PROGRESSIVE MONITORING LOOP
# ============================================

progressive_monitor() {
    local mysql_pass="$1"
    
    echo -e "${BLUE}[DOING NOW]: Starting progressive monitoring${NC}"
    echo -e "${WHITE}Will check every 30 seconds for completed downloads${NC}"
    echo ""
    
    local monitor_count=0
    
    while [ "$DOWNLOADS_ACTIVE" = true ]; do
        monitor_count=$((monitor_count + 1))
        
        echo -e "${BLUE}Monitor cycle $monitor_count - $(date)${NC}"
        
        # Check for newly completed files
        local ready_files=($(monitor_downloads))
        
        # Process any ready files that haven't been processed yet
        local new_ready=()
        for file in "${ready_files[@]}"; do
            if [ ! -f "/home/maverick/.mmp/processed_${file%.csv}.flag" ]; then
                new_ready+=("$file")
            fi
        done
        
        if [ ${#new_ready[@]} -gt 0 ]; then
            echo -e "${GREEN}Found ${#new_ready[@]} new completed file(s)${NC}"
            process_ready_files "$mysql_pass" "${new_ready[@]}"
        else
            echo -e "${WHITE}No new files ready for processing${NC}"
        fi
        
        # Check if downloads are still active (for this user)
        local active_downloads=$(pgrep -u $(whoami) -f "wget.*csv" | wc -l)
        if [ "$active_downloads" -eq 0 ]; then
            echo -e "${GREEN}[SUCCESS]: All downloads completed${NC}"
            DOWNLOADS_ACTIVE=false
        else
            echo -e "${BLUE}Still $active_downloads active download(s)${NC}"
            echo -e "${WHITE}Waiting 30 seconds before next check...${NC}"
            sleep 30
        fi
        
        echo ""
    done
}

# ============================================
# NORMALIZATION TRIGGER
# ============================================

run_normalization() {
    echo -e "${BLUE}[STEP 5/5 - ID: $INSTALLATION_ID]: Running normalization${NC}"
    
    # Check if unified_crime_normalizer.sh exists in various locations
    local normalizer_script=""
    for location in "/root/unified_crime_normalizer.sh" "/home/maverick/unified_crime_normalizer.sh" "./unified_crime_normalizer.sh"; do
        if [ -f "$location" ]; then
            normalizer_script="$location"
            break
        fi
    done
    
    if [ -n "$normalizer_script" ]; then
        echo -e "${WHITE}[DOING NOW]: Running unified crime normalizer: $normalizer_script${NC}"
        if bash "$normalizer_script"; then
            echo -e "${GREEN}[SUCCESS]: Normalization completed${NC}"
        else
            echo -e "${ORANGE}[WARNING]: Normalization encountered issues${NC}"
            echo -e "${WHITE}You can run it manually later: $normalizer_script${NC}"
        fi
    else
        echo -e "${ORANGE}[WARNING]: Normalization script not found${NC}"
        echo -e "${WHITE}Expected locations:${NC}"
        echo -e "${WHITE}  - /root/unified_crime_normalizer.sh${NC}"
        echo -e "${WHITE}  - /home/maverick/unified_crime_normalizer.sh${NC}"
        echo -e "${WHITE}  - ./unified_crime_normalizer.sh${NC}"
        echo -e "${WHITE}Skipping normalization step${NC}"
    fi
}

# ============================================
# MAIN EXECUTION
# ============================================

clear
echo -e "${WHITE}=============================================${NC}"
echo -e "${BLUE}   MMP CRIME DATA INTELLIGENT LOADER${NC}"
echo -e "${BLUE}   [Installation ID: $INSTALLATION_ID]${NC}"
echo -e "${BLUE}   [User: $(whoami)]${NC}"
echo -e "${WHITE}=============================================${NC}"
echo ""
echo -e "${GREEN}This intelligent loader will:${NC}"
echo -e "${WHITE}• Check for running processes and conflicts${NC}"
echo -e "${WHITE}• Monitor downloads and process completed files${NC}"
echo -e "${WHITE}• Load data into city-specific tables first${NC}"
echo -e "${WHITE}• Run normalization after all data is loaded${NC}"
echo -e "${WHITE}• Handle interruptions gracefully${NC}"
echo ""
echo -e "${WHITE}Press Ctrl+C to cancel, or wait 5 seconds to continue...${NC}"
sleep 5

# Execute main workflow
verify_user_setup
check_running_instances

MYSQL_PASS=$(get_mysql_credentials)

# Get initial file status
ready_files=($(monitor_downloads))

# Process any immediately ready files
if [ ${#ready_files[@]} -gt 0 ]; then
    process_ready_files "$MYSQL_PASS" "${ready_files[@]}"
fi

# If downloads are still active, start progressive monitoring
if [ "$DOWNLOADS_ACTIVE" = true ]; then
    progressive_monitor "$MYSQL_PASS"
fi

# Final check and processing
echo -e "${BLUE}[DOING NOW]: Final processing check${NC}"
ready_files=($(monitor_downloads))
new_ready=()
for file in "${ready_files[@]}"; do
    if [ ! -f "/home/maverick/.mmp/processed_${file%.csv}.flag" ]; then
        new_ready+=("$file")
    fi
done

if [ ${#new_ready[@]} -gt 0 ]; then
    process_ready_files "$MYSQL_PASS" "${new_ready[@]}"
fi

# Run normalization if all files are processed
local total_processed=$(ls /home/maverick/.mmp/processed_*.flag 2>/dev/null | wc -l)
if [ "$total_processed" -ge 3 ]; then  # Expecting at least chicago, seattle, and one LA file
    run_normalization
else
    echo -e "${ORANGE}[WARNING]: Not all files processed, skipping normalization${NC}"
    echo -e "${WHITE}You can run normalization manually later${NC}"
fi

echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  INTELLIGENT LOADING COMPLETE!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "${WHITE}Summary:${NC}"
echo -e "${GREEN}✓ Conflict detection and process management${NC}"
echo -e "${GREEN}✓ Progressive file monitoring and processing${NC}"
echo -e "${GREEN}✓ City-specific table population${NC}"
if [ "$total_processed" -ge 3 ]; then
    echo -e "${GREEN}✓ Unified table normalization${NC}"
fi
echo ""
echo -e "${BLUE}Next: Run 'mmp_status' to verify all data${NC}"
echo -e "${BLUE}      Use 'mmp_unified stats' for unified data analysis${NC}"
echo -e "${WHITE}=============================================${NC}"

# Cleanup happens automatically via trap
```

Now make it executable:

```bash
chmod +x /usr/local/bin/mmp_load
```

## Key Changes for Maverick User:

✅ **User Verification**: Checks if running as maverick user
✅ **Corrected Paths**: Uses `/home/maverick/.mmp/` for logs and temp files
✅ **User-Specific Locks**: Lock files include username to avoid conflicts
✅ **Process Detection**: Only looks for processes owned by the current user
✅ **Permissions**: All temp files created in maverick's home directory
✅ **Data Directory**: Confirms `/data/crime_data/raw` exists (owned by maverick)
✅ **Python Packages**: Installs with `--user` flag for user-local installation
✅ **Normalization**: Looks for script in multiple locations including maverick's home

## Usage as Maverick:

```bash
# Switch to maverick user first
su - maverick

# Then run the loader
mmp_load

# Or run directly if already maverick
mmp_load
```

This version is properly designed for the maverick user environment that v04 sets up!

---
**UNKNOWN**

soteh version i gave you insided a normaaliation proces didntit?

---
**UNKNOWN**

 Yes, you're absolutely right! Looking at the unified_crime_normalizer.sh script you provided, it's a complete normalization process that:

1. **Creates the unified_crimes table** with normalized schema
2. **Migrates data** from all three city tables (Chicago, LA, Seattle)
3. **Creates analysis views** (v_crime_stats_by_city_year, v_top_crimes_by_city, etc.)
4. **Generates summary statistics**
5. **Creates utility commands** (mmp_unified)

So the `mmp_load` script I just created should:

1. Load the raw CSV data into the **original city tables** (chicago_crimes, la_crimes, seattle_crimes)
2. **Then automatically run your unified_crime_normalizer.sh** script

The unified_crime_normalizer.sh you provided is the complete normalization system that takes data from the city tables and creates the unified structure.

Do you want me to:

1. **Update the mmp_load script** to better integrate with your existing unified_crime_normalizer.sh?
2. **Make sure it finds and runs your normalization script** properly?
3. **Or modify something specific** about how they work together?

The current mmp_load will load the city tables first, then call your normalization script. Is that the workflow you want, or should I adjust something?

---
**UNKNOWN**

does this have a noirmalizer script:

---
**UNKNOWN**

 Looking at the v04 script you just provided, **NO** - it does NOT include a normalizer script. 

The v04 script only:

1. **Creates the basic city tables** (chicago_crimes, la_crimes, seattle_crimes)
2. **Sets up downloads** 
3. **Creates utility commands** (mmp_status, mmp_check, mmp_help, etc.)

But it does **NOT** include:
- The unified_crimes table creation
- Data migration/normalization process
- The unified analysis views
- The mmp_unified commands

So the workflow should be:

1. **v04 script** → Sets up system, downloads data, creates city tables
2. **mmp_load** → Loads CSV data into the city tables 
3. **unified_crime_normalizer.sh** → Creates unified table and migrates data

The unified_crime_normalizer.sh script you provided earlier is a **separate script** that needs to be added to the system. That's why my `mmp_load` script looks for it in the normalization step.

So yes, you're absolutely right - the normalization process is separate from v04, and that's the correct design. The `mmp_load` I created will:

1. Load the raw data into city tables
2. Then automatically call your `unified_crime_normalizer.sh` script to create the unified structure

This separation is actually good design - keeps the installation script focused on setup, and the normalization as a separate, reusable process.

---
**UNKNOWN**

if i log out and log back in por rebooot i wont be maveriuckl

---
**UNKNOWN**

 You're absolutely right! After logout/reboot, you'll be back to root and need to switch to maverick. Let me update the `mmp_load` script to handle this properly:

```bash
nano /usr/local/bin/mmp_load
```

Add this section right at the beginning after the colors:

```bash
#!/bin/bash
# mmp_load - Intelligent Crime Data Processor v04
# Enhanced with automatic user switching and session management

# Colors - Matching v04 color scheme exactly
RED='\033[0;31m'        # CRITICAL SYSTEM HARM WARNING
ORANGE='\033[38;5;214m'  # HIGH ATTENTION WARNING  
GREEN='\033[0;32m'       # SUCCESS/GOOD
BLUE='\033[0;34m'        # INFORMATION/PROCESS
WHITE='\033[1;37m'       # NORMAL TEXT
NC='\033[0m'            # NO COLOR

# ============================================
# AUTOMATIC USER SWITCHING
# ============================================

check_and_switch_user() {
    local current_user=$(whoami)
    
    echo -e "${BLUE}Current user: $current_user${NC}"
    
    if [ "$current_user" = "root" ]; then
        echo -e "${ORANGE}[SWITCHING]: Running as root, switching to maverick user${NC}"
        echo -e "${WHITE}This script needs to run as maverick user for proper file permissions${NC}"
        echo ""
        
        # Check if maverick user exists
        if ! id maverick &>/dev/null; then
            echo -e "${RED}[CRITICAL ERROR]: Maverick user not found${NC}"
            echo -e "${WHITE}Please run the v04 installation script first${NC}"
            exit 1
        fi
        
        # Check if maverick has proper setup
        if [ ! -d "/home/maverick" ]; then
            echo -e "${RED}[CRITICAL ERROR]: Maverick home directory not found${NC}"
            exit 1
        fi
        
        echo -e "${BLUE}[DOING NOW]: Switching to maverick user and re-executing script${NC}"
        echo -e "${WHITE}You may be prompted for the maverick password${NC}"
        echo ""
        
        # Re-execute this script as maverick
        exec su - maverick -c "$(realpath "$0")"
        
    elif [ "$current_user" = "maverick" ]; then
        echo -e "${GREEN}✓ Running as maverick user${NC}"
        
    else
        echo -e "${ORANGE}[WARNING]: Running as user '$current_user'${NC}"
        echo -e "${WHITE}This script is designed to run as 'maverick' user${NC}"
        echo -e "${WHITE}Do you want to continue anyway? (y/n):${NC}"
        read -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Please switch to maverick user: su - maverick"
            exit 0
        fi
    fi
}

# ============================================
# SESSION RECOVERY FUNCTIONS
# ============================================

create_session_info() {
    local session_file="/home/maverick/.mmp/current_session.info"
    
    cat > "$session_file" << EOF
SESSION_START=$(date)
USER=$(whoami)
HOSTNAME=$(hostname)
INSTALLATION_ID=$INSTALLATION_ID
SCRIPT_VERSION=04
LAST_ACTIVITY=$(date +%s)
EOF
    
    chmod 600 "$session_file"
    echo -e "${BLUE}[SESSION]: Created session tracking${NC}"
}

check_previous_session() {
    local session_file="/home/maverick/.mmp/current_session.info"
    
    if [ -f "$session_file" ]; then
        echo -e "${BLUE}[SESSION]: Found previous session information${NC}"
        source "$session_file" 2>/dev/null
        
        echo -e "${WHITE}Previous session:${NC}"
        echo -e "${WHITE}  Started: $SESSION_START${NC}"
        echo -e "${WHITE}  User: $USER${NC}"
        echo -e "${WHITE}  Host: $HOSTNAME${NC}"
        echo ""
        
        # Check for incomplete processing
        local processed_files=$(ls /home/maverick/.mmp/processed_*.flag 2>/dev/null | wc -l)
        if [ "$processed_files" -gt 0 ]; then
            echo -e "${GREEN}Found $processed_files previously processed files${NC}"
            echo -e "${WHITE}Will resume from where we left off${NC}"
        fi
        echo ""
    fi
}

# Rest of your existing script continues here...
# Configuration
LOCK_FILE="/tmp/mmp_load_$(whoami).lock"
DOWNLOAD_LOCK="/tmp/mmp_download_$(whoami).lock"
LOG_FILE="/home/maverick/.mmp/mmp_load.log"
PROCESS_DIR="/tmp/mmp_processing_$(whoami)"
INSTALLATION_ID=$(cat /root/mmp_logs/progress.txt 2>/dev/null | tail -1 | cut -d'|' -f4 || echo "UNKNOWN")

# ... rest of existing functions remain the same ...

# ============================================
# MAIN EXECUTION WITH USER SWITCHING
# ============================================

clear
echo -e "${WHITE}=============================================${NC}"
echo -e "${BLUE}   MMP CRIME DATA INTELLIGENT LOADER${NC}"
echo -e "${BLUE}   [Installation ID: $INSTALLATION_ID]${NC}"
echo -e "${WHITE}=============================================${NC}"
echo ""

# Check and switch user if needed
check_and_switch_user

# Check for previous session
check_previous_session

# Create new session info
create_session_info

echo -e "${GREEN}This intelligent loader will:${NC}"
echo -e "${WHITE}• Automatically handle user switching${NC}"
echo -e "${WHITE}• Check for running processes and conflicts${NC}"
echo -e "${WHITE}• Monitor downloads and process completed files${NC}"
echo -e "${WHITE}• Load data into city-specific tables first${NC}"
echo -e "${WHITE}• Run normalization after all data is loaded${NC}"
echo -e "${WHITE}• Handle interruptions gracefully${NC}"
echo ""
echo -e "${WHITE}Press Ctrl+C to cancel, or wait 5 seconds to continue...${NC}"
sleep 5

# Continue with existing workflow...
```

Also create a helper script that makes it easy to get back to the right state:

```bash
nano /usr/local/bin/mmp_session
```

```bash
#!/bin/bash
# mmp_session - Quick session management for MMP Crime Database

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}   MMP SESSION MANAGER${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

current_user=$(whoami)

if [ "$current_user" = "root" ]; then
    echo -e "${WHITE}Currently logged in as: ${RED}root${NC}"
    echo -e "${WHITE}MMP Crime Database should be accessed as: ${GREEN}maverick${NC}"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo -e "${WHITE}1. Switch to maverick user${NC}"
    echo -e "${WHITE}2. Check maverick user status${NC}"
    echo -e "${WHITE}3. Show session information${NC}"
    echo -e "${WHITE}4. Run mmp_status as maverick${NC}"
    echo ""
    read -p "Choose option (1-4): " -n 1 -r
    echo ""
    
    case $REPLY in
        1)
            echo -e "${BLUE}Switching to maverick user...${NC}"
            exec su - maverick
            ;;
        2)
            echo -e "${BLUE}Checking maverick user...${NC}"
            if id maverick &>/dev/null; then
                echo -e "${GREEN}✓ Maverick user exists${NC}"
                if [ -d "/home/maverick" ]; then
                    echo -e "${GREEN}✓ Home directory exists${NC}"
                else
                    echo -e "${RED}✗ Home directory missing${NC}"
                fi
            else
                echo -e "${RED}✗ Maverick user not found${NC}"
            fi
            ;;
        3)
            if [ -f "/home/maverick/.mmp/current_session.info" ]; then
                echo -e "${GREEN}Session information:${NC}"
                cat "/home/maverick/.mmp/current_session.info"
            else
                echo -e "${WHITE}No session information found${NC}"
            fi
            ;;
        4)
            echo -e "${BLUE}Running mmp_status as maverick...${NC}"
            su - maverick -c "mmp_status"
            ;;
        *)
            echo -e "${WHITE}Invalid option${NC}"
            ;;
    esac
    
elif [ "$current_user" = "maverick" ]; then
    echo -e "${WHITE}Currently logged in as: ${GREEN}maverick${NC}"
    echo -e "${GREEN}✓ Ready to use MMP Crime Database${NC}"
    echo ""
    echo -e "${BLUE}Quick Commands:${NC}"
    echo -e "${WHITE}• mmp_status  - Check system status${NC}"
    echo -e "${WHITE}• mmp_check   - Check download progress${NC}"
    echo -e "${WHITE}• mmp_load    - Load/process crime data${NC}"
    echo -e "${WHITE}• mmp_help    - Show all commands${NC}"
    
else
    echo -e "${WHITE}Currently logged in as: ${current_user}${NC}"
    echo -e "${WHITE}Switch to maverick user: ${GREEN}su - maverick${NC}"
fi

echo ""
echo -e "${WHITE}=============================================${NC}"
```

Make both executable:

```bash
chmod +x /usr/local/bin/mmp_session
```

Now users can:

**After reboot/logout:**
```bash
# Quick way to get to the right user and check status
mmp_session

# Or directly run commands (will auto-switch)
mmp_load

# Or manually switch
su - maverick
```

**The `mmp_load` script will automatically:**
1. Detect if running as root
2. Switch to maverick user 
3. Re-execute itself as maverick
4. Continue with the data loading process

This makes it much more user-friendly for people who log back in as root!

---
**UNKNOWN**

i need that in one file

---
**UNKNOWN**

 Here's the complete `mmp_load` script with automatic user switching in one file:

```bash
nano /usr/local/bin/mmp_load
```

```bash
#!/bin/bash
# mmp_load - Intelligent Crime Data Processor v04
# Enhanced with automatic user switching, conflict detection, progressive processing, and normalization
# Designed to auto-switch from root to maverick user after v04 installation

# Colors - Matching v04 color scheme exactly
RED='\033[0;31m'        # CRITICAL SYSTEM HARM WARNING
ORANGE='\033[38;5;214m'  # HIGH ATTENTION WARNING  
GREEN='\033[0;32m'       # SUCCESS/GOOD
BLUE='\033[0;34m'        # INFORMATION/PROCESS
WHITE='\033[1;37m'       # NORMAL TEXT
NC='\033[0m'            # NO COLOR

# ============================================
# AUTOMATIC USER SWITCHING
# ============================================

check_and_switch_user() {
    local current_user=$(whoami)
    
    echo -e "${BLUE}Current user: $current_user${NC}"
    
    if [ "$current_user" = "root" ]; then
        echo -e "${ORANGE}[SWITCHING]: Running as root, switching to maverick user${NC}"
        echo -e "${WHITE}This script needs to run as maverick user for proper file permissions${NC}"
        echo ""
        
        # Check if maverick user exists
        if ! id maverick &>/dev/null; then
            echo -e "${RED}[CRITICAL ERROR]: Maverick user not found${NC}"
            echo -e "${WHITE}Please run the v04 installation script first${NC}"
            exit 1
        fi
        
        # Check if maverick has proper setup
        if [ ! -d "/home/maverick" ]; then
            echo -e "${RED}[CRITICAL ERROR]: Maverick home directory not found${NC}"
            exit 1
        fi
        
        echo -e "${BLUE}[DOING NOW]: Switching to maverick user and re-executing script${NC}"
        echo -e "${WHITE}You may be prompted for the maverick password${NC}"
        echo ""
        
        # Re-execute this script as maverick
        exec su - maverick -c "$(realpath "$0")"
        
    elif [ "$current_user" = "maverick" ]; then
        echo -e "${GREEN}✓ Running as maverick user${NC}"
        
    else
        echo -e "${ORANGE}[WARNING]: Running as user '$current_user'${NC}"
        echo -e "${WHITE}This script is designed to run as 'maverick' user${NC}"
        echo -e "${WHITE}Do you want to continue anyway? (y/n):${NC}"
        read -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Please switch to maverick user: su - maverick"
            exit 0
        fi
    fi
}

# ============================================
# SESSION RECOVERY FUNCTIONS
# ============================================

create_session_info() {
    local session_file="/home/maverick/.mmp/current_session.info"
    
    mkdir -p "/home/maverick/.mmp" 2>/dev/null
    chmod 700 "/home/maverick/.mmp" 2>/dev/null
    
    cat > "$session_file" << EOF
SESSION_START=$(date)
USER=$(whoami)
HOSTNAME=$(hostname)
INSTALLATION_ID=$INSTALLATION_ID
SCRIPT_VERSION=04
LAST_ACTIVITY=$(date +%s)
EOF
    
    chmod 600 "$session_file"
    echo -e "${BLUE}[SESSION]: Created session tracking${NC}"
}

check_previous_session() {
    local session_file="/home/maverick/.mmp/current_session.info"
    
    if [ -f "$session_file" ]; then
        echo -e "${BLUE}[SESSION]: Found previous session information${NC}"
        source "$session_file" 2>/dev/null
        
        echo -e "${WHITE}Previous session:${NC}"
        echo -e "${WHITE}  Started: $SESSION_START${NC}"
        echo -e "${WHITE}  User: $USER${NC}"
        echo -e "${WHITE}  Host: $HOSTNAME${NC}"
        echo ""
        
        # Check for incomplete processing
        local processed_files=$(ls /home/maverick/.mmp/processed_*.flag 2>/dev/null | wc -l)
        if [ "$processed_files" -gt 0 ]; then
            echo -e "${GREEN}Found $processed_files previously processed files${NC}"
            echo -e "${WHITE}Will resume from where we left off${NC}"
        fi
        echo ""
    fi
}

# Configuration for maverick user
LOCK_FILE="/tmp/mmp_load_$(whoami).lock"
DOWNLOAD_LOCK="/tmp/mmp_download_$(whoami).lock"
LOG_FILE="/home/maverick/.mmp/mmp_load.log"
PROCESS_DIR="/tmp/mmp_processing_$(whoami)"
INSTALLATION_ID=$(cat /root/mmp_logs/progress.txt 2>/dev/null | tail -1 | cut -d'|' -f4 || echo "UNKNOWN")

# Process tracking
declare -A CITY_STATUS
declare -A FILE_SIZES
DOWNLOADS_ACTIVE=false

# ============================================
# USER VERIFICATION AND SETUP
# ============================================

verify_user_setup() {
    echo -e "${BLUE}[VERIFICATION]: Checking user setup for data loading${NC}"
    
    # Check if maverick home directory exists
    if [ ! -d "/home/maverick" ]; then
        echo -e "${RED}[CRITICAL ERROR]: Maverick user not properly set up${NC}"
        exit 1
    fi
    
    # Create log directory if it doesn't exist
    mkdir -p "/home/maverick/.mmp" 2>/dev/null
    chmod 700 "/home/maverick/.mmp" 2>/dev/null
    
    # Check data directory
    if [ ! -d "/data/crime_data/raw" ]; then
        echo -e "${RED}[CRITICAL ERROR]: Data directory not found${NC}"
        echo -e "${WHITE}Expected: /data/crime_data/raw${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[SUCCESS]: User setup verified${NC}"
}

# ============================================
# CONFLICT DETECTION AND PROCESS MANAGEMENT
# ============================================

cleanup() {
    echo -e "${BLUE}[CLEANUP]: Removing lock files and temporary data${NC}"
    rm -f "$LOCK_FILE" "$DOWNLOAD_LOCK" 2>/dev/null
    rm -rf "$PROCESS_DIR" 2>/dev/null
    exit 0
}

wait_for_process() {
    local pid="$1"
    local wait_time=0
    echo -e "${BLUE}[WAITING]: Monitoring process $pid...${NC}"
    
    while kill -0 "$pid" 2>/dev/null; do
        sleep 10
        wait_time=$((wait_time + 10))
        echo -e "${WHITE}Still waiting... ${wait_time}s elapsed${NC}"
        
        if [ $wait_time -gt 300 ]; then
            echo -e "${ORANGE}[WARNING]: Process taking longer than 5 minutes${NC}"
            echo -e "${WHITE}Continue waiting? (y/n):${NC}"
            read -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                break
            fi
        fi
    done
}

check_running_instances() {
    echo -e "${BLUE}[STEP 1/5 - ID: $INSTALLATION_ID]: Checking for running instances${NC}"
    
    # Check for existing mmp_load processes for this user
    if [ -f "$LOCK_FILE" ]; then
        local lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
        if kill -0 "$lock_pid" 2>/dev/null; then
            echo -e "${ORANGE}[ERROR 1]: mmp_load already running for $(whoami) (PID: $lock_pid)${NC}"
            echo -e "${WHITE}Options:${NC}"
            echo -e "${WHITE}1. Wait for current process to complete${NC}"
            echo -e "${WHITE}2. Kill existing process and restart${NC}"
            echo -e "${WHITE}3. Exit and check manually${NC}"
            echo ""
            read -p "Choose option (1-3): " -n 1 -r
            echo ""
            
            case $REPLY in
                1)
                    echo -e "${BLUE}[DOING NOW]: Waiting for existing process...${NC}"
                    wait_for_process "$lock_pid"
                    ;;
                2)
                    echo -e "${ORANGE}[DOING NOW]: Terminating existing process...${NC}"
                    kill -TERM "$lock_pid" 2>/dev/null
                    sleep 3
                    kill -KILL "$lock_pid" 2>/dev/null
                    rm -f "$LOCK_FILE"
                    echo -e "${GREEN}[SUCCESS]: Previous process terminated${NC}"
                    ;;
                3)
                    echo -e "${WHITE}Exiting. Check processes with: ps aux | grep mmp${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}[CRITICAL ERROR 1]: Invalid option${NC}"
                    exit 1
                    ;;
            esac
        else
            # Stale lock file
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # Check for download processes (look for maverick's processes)
    local download_processes=$(pgrep -u $(whoami) -f "download_crime_data\|wget.*csv" | wc -l)
    if [ "$download_processes" -gt 0 ]; then
        echo -e "${BLUE}⚡ Downloads still active ($download_processes processes)${NC}"
        echo -e "${WHITE}Will monitor and process files as they complete...${NC}"
        DOWNLOADS_ACTIVE=true
    else
        echo -e "${GREEN}✓ No active downloads detected${NC}"
        DOWNLOADS_ACTIVE=false
    fi
    
    # Create our lock and set cleanup trap
    echo $$ > "$LOCK_FILE"
    trap cleanup EXIT INT TERM
    
    echo -e "${GREEN}[SUCCESS]: Process checks completed${NC}"
}

# ============================================
# DATABASE CREDENTIAL MANAGEMENT
# ============================================

get_mysql_credentials() {
    echo -e "${BLUE}[STEP 2/5 - ID: $INSTALLATION_ID]: Retrieving database credentials${NC}"
    
    # Try to get from mmp_decrypt first
    local mysql_pass=""
    if command -v mmp_decrypt >/dev/null; then
        mysql_pass=$(echo "" | mmp_decrypt 2>/dev/null | grep "MySQL app" | cut -d'/' -f2 | xargs || echo "")
    fi
    
    # Fallback methods
    if [ -z "$mysql_pass" ]; then
        echo -e "${ORANGE}[WARNING]: Could not auto-retrieve MySQL password${NC}"
        echo -e "${WHITE}Enter MySQL crime_analyst password:${NC}"
        read -s mysql_pass
    fi
    
    # Test database connection
    echo -e "${WHITE}[DOING NOW]: Testing database connection...${NC}"
    if mysql -u crime_analyst -p"$mysql_pass" crime_data -e "SELECT 1;" &>/dev/null; then
        echo -e "${GREEN}[SUCCESS]: Database connection verified${NC}"
        echo "$mysql_pass"
    else
        echo -e "${RED}[CRITICAL ERROR 2]: Cannot connect to database${NC}"
        echo -e "${RED}This could harm your system or compromise security!${NC}"
        exit 1
    fi
}

# ============================================
# FILE MONITORING AND STATUS TRACKING
# ============================================

check_file_completion() {
    local filepath="$1"
    local expected_min_size="$2"
    
    if [ ! -f "$filepath" ]; then
        return 1
    fi
    
    # Check if file is still growing
    local size1=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
    sleep 2
    local size2=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
    
    # File is complete if it's not growing and meets minimum size
    if [ "$size1" = "$size2" ] && [ "$size1" -gt "$expected_min_size" ]; then
        return 0
    else
        return 1
    fi
}

monitor_downloads() {
    echo -e "${BLUE}[STEP 3/5 - ID: $INSTALLATION_ID]: Monitoring download status${NC}"
    
    # Define expected files with minimum sizes (in bytes)
    declare -A expected_files=(
        ["chicago.csv"]="1000000000"     # ~1GB minimum
        ["la_old.csv"]="300000000"       # ~300MB minimum  
        ["la_new.csv"]="100000000"       # ~100MB minimum
        ["seattle.csv"]="2000000000"     # ~2GB minimum
    )
    
    echo -e "${WHITE}Checking file completion status:${NC}"
    
    local all_complete=true
    local ready_to_process=()
    
    for file in "${!expected_files[@]}"; do
        local filepath="/data/crime_data/raw/$file"
        local min_size="${expected_files[$file]}"
        
        if check_file_completion "$filepath" "$min_size"; then
            local size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
            echo -e "${GREEN}  $file: $size ✓ Ready${NC}"
            ready_to_process+=("$file")
            CITY_STATUS["$file"]="READY"
        elif [ -f "$filepath" ]; then
            local size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
            echo -e "${BLUE}  $file: $size ⚡ Downloading${NC}"
            CITY_STATUS["$file"]="DOWNLOADING"
            all_complete=false
        else
            echo -e "${ORANGE}  $file: Not found ✗${NC}"
            CITY_STATUS["$file"]="MISSING"
            all_complete=false
        fi
    done
    
    echo ""
    if [ ${#ready_to_process[@]} -gt 0 ]; then
        echo -e "${GREEN}Files ready for processing: ${#ready_to_process[@]}${NC}"
        echo "${ready_to_process[@]}"
    fi
    
    if [ "$all_complete" = true ]; then
        echo -e "${GREEN}[SUCCESS]: All downloads completed${NC}"
        DOWNLOADS_ACTIVE=false
    else
        echo -e "${BLUE}Downloads still in progress...${NC}"
        DOWNLOADS_ACTIVE=true
    fi
    
    echo "${ready_to_process[@]}"
}

# ============================================
# PYTHON DATA LOADING SYSTEM
# ============================================

install_python_dependencies() {
    echo -e "${BLUE}[DOING NOW]: Installing Python data packages${NC}"
    
    # Check if packages are already installed
    if python3 -c "import pandas, mysql.connector, tqdm" 2>/dev/null; then
        echo -e "${GREEN}✓ Python packages already installed${NC}"
        return 0
    fi
    
    echo -e "${WHITE}Installing: pandas, mysql-connector-python, tqdm${NC}"
    if python3 -m pip install --user pandas mysql-connector-python tqdm 2>/dev/null; then
        echo -e "${GREEN}[SUCCESS]: Python packages installed${NC}"
    else
        echo -e "${ORANGE}[WARNING]: Some Python packages may not have installed${NC}"
        echo -e "${WHITE}Continuing anyway...${NC}"
    fi
}

process_single_file() {
    local filename="$1"
    local mysql_pass="$2"
    
    echo -e "${BLUE}[DOING NOW]: Processing $filename${NC}"
    
    # Create Python loader script for this specific file in maverick's temp space
    local temp_script="/home/maverick/.mmp/load_${filename%.csv}.py"
    
    cat > "$temp_script" << PYEOF
#!/usr/bin/env python3
import pandas as pd
import mysql.connector
from datetime import datetime
import os
import sys
import time
import warnings
warnings.filterwarnings('ignore')

print(f"\\n=== MMP Data Loader for ${filename} ===")
print(f"Installation ID: $INSTALLATION_ID")
print(f"Timestamp: {datetime.now()}")
print(f"User: $(whoami)")
print()

# Database config
config = {
    'user': 'crime_analyst',
    'password': '$mysql_pass',
    'host': 'localhost',
    'database': 'crime_data',
    'autocommit': False
}

def show_progress(message, current=0, total=0):
    if total > 0:
        percent = (current / total) * 100
        print(f"\\r{message}: {current:,}/{total:,} ({percent:.1f}%)", end='', flush=True)
    else:
        print(f"\\r{message}...", end='', flush=True)

def clean_datetime(date_str):
    if pd.isna(date_str) or date_str == '':
        return None
    try:
        formats = [
            '%m/%d/%Y %I:%M:%S %p',
            '%Y-%m-%d %H:%M:%S',
            '%Y-%m-%dT%H:%M:%S.%f',
            '%Y-%m-%d',
            '%m/%d/%Y'
        ]
        date_str = str(date_str).strip()
        for fmt in formats:
            try:
                return datetime.strptime(date_str, fmt)
            except:
                continue
    except:
        pass
    return None

# Connect to database
print("Connecting to database...")
try:
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    print("✓ Connected successfully")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

file_path = "/data/crime_data/raw/${filename}"
if not os.path.exists(file_path):
    print(f"✗ File not found: {file_path}")
    sys.exit(1)

file_size = os.path.getsize(file_path) / (1024**3)
print(f"File: {file_path}")
print(f"Size: {file_size:.2f} GB")

chunk_size = 50000
total_loaded = 0
start_time = time.time()

try:
    # Determine table and processing based on filename
    if "chicago" in "${filename}":
        table_name = "chicago_crimes"
        cursor.execute("ALTER TABLE chicago_crimes DISABLE KEYS")
        
        for chunk_num, chunk in enumerate(pd.read_csv(file_path, chunksize=chunk_size, low_memory=False)):
            # Clean Chicago data
            if 'Date' in chunk.columns:
                chunk['Date'] = chunk['Date'].apply(clean_datetime)
            if 'Updated On' in chunk.columns:
                chunk['Updated On'] = chunk['Updated On'].apply(clean_datetime)
            if 'Arrest' in chunk.columns:
                chunk['Arrest'] = chunk['Arrest'].map({'true': 1, 'false': 0, True: 1, False: 0}).fillna(0)
            if 'Domestic' in chunk.columns:
                chunk['Domestic'] = chunk['Domestic'].map({'true': 1, 'false': 0, True: 1, False: 0}).fillna(0)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('Case Number'), row.get('Date'), row.get('Block'),
                    row.get('IUCR'), row.get('Primary Type'), row.get('Description'),
                    row.get('Location Description'), row.get('Arrest'), row.get('Domestic'),
                    row.get('Beat'), row.get('District'), row.get('Ward'),
                    row.get('Community Area'), row.get('FBI Code'), row.get('X Coordinate'),
                    row.get('Y Coordinate'), row.get('Year'), row.get('Updated On'),
                    row.get('Latitude'), row.get('Longitude'), row.get('Location')
                ))
            
            # Insert data
            insert_query = """
            INSERT IGNORE INTO chicago_crimes (
                case_number, date, block, iucr, primary_type, description,
                location_description, arrest, domestic, beat, district, ward,
                community_area, fbi_code, x_coordinate, y_coordinate, year,
                updated_on, latitude, longitude, location
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress("Processing Chicago", total_loaded)
        
        cursor.execute("ALTER TABLE chicago_crimes ENABLE KEYS")
        
    elif "la_" in "${filename}":
        table_name = "la_crimes"
        # Only disable keys once for LA files
        if not os.path.exists("/home/maverick/.mmp/la_keys_disabled.flag"):
            cursor.execute("ALTER TABLE la_crimes DISABLE KEYS")
            with open("/home/maverick/.mmp/la_keys_disabled.flag", "w") as f:
                f.write("disabled")
        
        for chunk in pd.read_csv(file_path, chunksize=chunk_size, low_memory=False):
            # Clean dates
            if 'Date Rptd' in chunk.columns:
                chunk['Date Rptd'] = chunk['Date Rptd'].apply(clean_datetime)
            if 'DATE OCC' in chunk.columns:
                chunk['DATE OCC'] = chunk['DATE OCC'].apply(clean_datetime)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('DR_NO'), row.get('Date Rptd'), row.get('DATE OCC'),
                    row.get('TIME OCC'), row.get('AREA'), row.get('AREA NAME'),
                    row.get('Rpt Dist No'), row.get('Part 1-2'), row.get('Crm Cd'),
                    row.get('Crm Cd Desc'), row.get('Mocodes'), row.get('Vict Age'),
                    row.get('Vict Sex'), row.get('Vict Descent'), row.get('Premis Cd'),
                    row.get('Premis Desc'), row.get('Weapon Used Cd'), row.get('Weapon Desc'),
                    row.get('Status'), row.get('Status Desc'), row.get('Crm Cd 1'),
                    row.get('Crm Cd 2'), row.get('Crm Cd 3'), row.get('Crm Cd 4'),
                    row.get('LOCATION'), row.get('Cross Street'), row.get('LAT'), row.get('LON')
                ))
            
            insert_query = """
            INSERT IGNORE INTO la_crimes (
                dr_no, date_rptd, date_occ, time_occ, area, area_name,
                rpt_dist_no, part_1_2, crm_cd, crm_cd_desc, mocodes,
                vict_age, vict_sex, vict_descent, premis_cd, premis_desc,
                weapon_used_cd, weapon_desc, status, status_desc,
                crm_cd_1, crm_cd_2, crm_cd_3, crm_cd_4, location,
                cross_street, lat, lon
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress(f"Processing LA ({os.path.basename(file_path)})", total_loaded)
        
    elif "seattle" in "${filename}":
        table_name = "seattle_crimes"
        cursor.execute("ALTER TABLE seattle_crimes DISABLE KEYS")
        
        for chunk in pd.read_csv(file_path, chunksize=chunk_size, low_memory=False):
            # Clean Seattle data
            date_cols = ['Offense Start DateTime', 'Offense End DateTime', 'Report DateTime']
            for col in date_cols:
                if col in chunk.columns:
                    chunk[col] = chunk[col].apply(clean_datetime)
            
            chunk = chunk.replace({pd.NA: None, 'NaN': None, '': None})
            
            # Prepare data
            data = []
            for _, row in chunk.iterrows():
                data.append((
                    row.get('Report Number'), row.get('Offense ID'),
                    row.get('Offense Start DateTime'), row.get('Offense End DateTime'),
                    row.get('Report DateTime'), row.get('NIBRS Group AB'),
                    row.get('NIBRS Crime Against Category'), row.get('Offense Category'),
                    row.get('Offense Sub Category'), row.get('Offense Code'),
                    row.get('Precinct'), row.get('Sector'), row.get('Beat'),
                    row.get('MCPP'), row.get('100 Block Address'),
                    row.get('Longitude'), row.get('Latitude')
                ))
            
            insert_query = """
            INSERT IGNORE INTO seattle_crimes (
                report_number, offense_id, offense_start_datetime, offense_end_datetime,
                report_datetime, group_a_b, crime_against_category, offense_parent_group,
                offense, offense_code, precinct, sector, beat, mcpp,
                _100_block_address, longitude, latitude
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """
            
            cursor.executemany(insert_query, data)
            conn.commit()
            
            total_loaded += len(data)
            show_progress("Processing Seattle", total_loaded)
        
        cursor.execute("ALTER TABLE seattle_crimes ENABLE KEYS")
        
    elapsed = time.time() - start_time
    print(f"\\n✓ {os.path.basename(file_path)} complete: {total_loaded:,} records in {elapsed:.1f} seconds")
    
    # Mark as processed in maverick's space
    with open("/home/maverick/.mmp/processed_${filename%.csv}.flag", "w") as f:
        f.write(f"{total_loaded}\\n{elapsed:.1f}\\n{datetime.now()}\\n")
    
except Exception as e:
    print(f"\\n✗ Error processing ${filename}: {e}")
    conn.rollback()
    sys.exit(1)

cursor.close()
conn.close()
print(f"Database connection closed for ${filename}")

PYEOF

    # Execute the Python script
    if python3 "$temp_script"; then
        echo -e "${GREEN}[SUCCESS]: $filename processed successfully${NC}"
        CITY_STATUS["$filename"]="PROCESSED"
        
        # Special handling for LA files - enable keys after both are done
        if [[ "$filename" == "la_"* ]]; then
            local other_la_file=""
            if [[ "$filename" == "la_old.csv" ]]; then
                other_la_file="la_new.csv"
            else
                other_la_file="la_old.csv"
            fi
            
            if [ -f "/home/maverick/.mmp/processed_${other_la_file%.csv}.flag" ]; then
                echo -e "${BLUE}[DOING NOW]: Enabling LA crimes table keys${NC}"
                mysql -u crime_analyst -p"$mysql_pass" crime_data -e "ALTER TABLE la_crimes ENABLE KEYS;" 2>/dev/null
                rm -f "/home/maverick/.mmp/la_keys_disabled.flag" 2>/dev/null
                echo -e "${GREEN}[SUCCESS]: LA crimes table optimized${NC}"
            fi
        fi
        
        # Clean up the temp script
        rm -f "$temp_script"
        return 0
    else
        echo -e "${ORANGE}[ERROR]: Failed to process $filename${NC}"
        CITY_STATUS["$filename"]="FAILED"
        rm -f "$temp_script"
        return 1
    fi
}

# ============================================
# MAIN PROCESSING ORCHESTRATOR
# ============================================

process_ready_files() {
    local mysql_pass="$1"
    local ready_files=("${@:2}")
    
    echo -e "${BLUE}[STEP 4/5 - ID: $INSTALLATION_ID]: Processing ready files${NC}"
    
    if [ ${#ready_files[@]} -eq 0 ]; then
        echo -e "${ORANGE}[WARNING]: No files ready for processing${NC}"
        return 0
    fi
    
    install_python_dependencies
    
    local processed_count=0
    local failed_count=0
    
    for file in "${ready_files[@]}"; do
        echo ""
        echo -e "${WHITE}=============================================${NC}"
        echo -e "${BLUE}Processing: $file${NC}"
        echo -e "${WHITE}=============================================${NC}"
        
        if process_single_file "$file" "$mysql_pass"; then
            processed_count=$((processed_count + 1))
        else
            failed_count=$((failed_count + 1))
        fi
    done
    
    echo ""
    echo -e "${WHITE}Processing Summary:${NC}"
    echo -e "${GREEN}Successful: $processed_count${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "${ORANGE}Failed: $failed_count${NC}"
    fi
}

# ============================================
# PROGRESSIVE MONITORING LOOP
# ============================================

progressive_monitor() {
    local mysql_pass="$1"
    
    echo -e "${BLUE}[DOING NOW]: Starting progressive monitoring${NC}"
    echo -e "${WHITE}Will check every 30 seconds for completed downloads${NC}"
    echo ""
    
    local monitor_count=0
    
    while [ "$DOWNLOADS_ACTIVE" = true ]; do
        monitor_count=$((monitor_count + 1))
        
        echo -e "${BLUE}Monitor cycle $monitor_count - $(date)${NC}"
        
        # Check for newly completed files
        local ready_files=($(monitor_downloads))
        
        # Process any ready files that haven't been processed yet
        local new_ready=()
        for file in "${ready_files[@]}"; do
            if [ ! -f "/home/maverick/.mmp/processed_${file%.csv}.flag" ]; then
                new_ready+=("$file")
            fi
        done
        
        if [ ${#new_ready[@]} -gt 0 ]; then
            echo -e "${GREEN}Found ${#new_ready[@]} new completed file(s)${NC}"
            process_ready_files "$mysql_pass" "${new_ready[@]}"
        else
            echo -e "${WHITE}No new files ready for processing${NC}"
        fi
        
        # Check if downloads are still active (for this user)
        local active_downloads=$(pgrep -u $(whoami) -f "wget.*csv" | wc -l)
        if [ "$active_downloads" -eq 0 ]; then
            echo -e "${GREEN}[SUCCESS]: All downloads completed${NC}"
            DOWNLOADS_ACTIVE=false
        else
            echo -e "${BLUE}Still $active_downloads active download(s)${NC}"
            echo -e "${WHITE}Waiting 30 seconds before next check...${NC}"
            sleep 30
        fi
        
        echo ""
    done
}

# ============================================
# NORMALIZATION TRIGGER
# ============================================

run_normalization() {
    echo -e "${BLUE}[STEP 5/5 - ID: $INSTALLATION_ID]: Running normalization${NC}"
    
    # Check if unified_crime_normalizer.sh exists in various locations
    local normalizer_script=""
    for location in "/home/maverick/unified_crime_normalizer.sh" "/root/unified_crime_normalizer.sh" "./unified_crime_normalizer.sh"; do
        if [ -f "$location" ]; then
            normalizer_script="$location"
            break
        fi
    done
    
    if [ -n "$normalizer_script" ]; then
        echo -e "${WHITE}[DOING NOW]: Running unified crime normalizer: $normalizer_script${NC}"
        if bash "$normalizer_script"; then
            echo -e "${GREEN}[SUCCESS]: Normalization completed${NC}"
        else
            echo -e "${ORANGE}[WARNING]: Normalization encountered issues${NC}"
            echo -e "${WHITE}You can run it manually later: $normalizer_script${NC}"
        fi
    else
        echo -e "${ORANGE}[WARNING]: Normalization script not found${NC}"
        echo -e "${WHITE}Expected locations:${NC}"
        echo -e "${WHITE}  - /home/maverick/unified_crime_normalizer.sh${NC}"
        echo -e "${WHITE}  - /root/unified_crime_normalizer.sh${NC}"
        echo -e "${WHITE}  - ./unified_crime_normalizer.sh${NC}"
        echo -e "${WHITE}Skipping normalization step${NC}"
    fi
}

# ============================================
# SESSION MANAGER FUNCTION
# ============================================

show_session_help() {
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}   MMP SESSION MANAGER${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo ""
    echo -e "${WHITE}Quick Commands:${NC}"
    echo -e "${WHITE}• mmp_status  - Check system status${NC}"
    echo -e "${WHITE}• mmp_check   - Check download progress${NC}"
    echo -e "${WHITE}• mmp_load    - Load/process crime data${NC}"
    echo -e "${WHITE}• mmp_help    - Show all commands${NC}"
    echo ""
    
    if [ -f "/home/maverick/.mmp/current_session.info" ]; then
        echo -e "${GREEN}Session information:${NC}"
        cat "/home/maverick/.mmp/current_session.info"
    else
        echo -e "${WHITE}No session information found${NC}"
    fi
    echo ""
    echo -e "${WHITE}=============================================${NC}"
}

# ============================================
# MAIN EXECUTION WITH USER SWITCHING
# ============================================

# Check for session manager mode
if [ "$1" = "--session" ]; then
    show_session_help
    exit 0
fi

clear
echo -e "${WHITE}=============================================${NC}"
echo -e "${BLUE}   MMP CRIME DATA INTELLIGENT LOADER${NC}"
echo -e "${BLUE}   [Installation ID: $INSTALLATION_ID]${NC}"
echo -e "${WHITE}=============================================${NC}"
echo ""

# Check and switch user if needed
check_and_switch_user

# Check for previous session
check_previous_session

# Create new session info
create_session_info

echo -e "${GREEN}This intelligent loader will:${NC}"
echo -e "${WHITE}• Automatically handle user switching${NC}"
echo -e "${WHITE}• Check for running processes and conflicts${NC}"
echo -e "${WHITE}• Monitor downloads and process completed files${NC}"
echo -e "${WHITE}• Load data into city-specific tables first${NC}"
echo -e "${WHITE}• Run normalization after all data is loaded${NC}"
echo -e "${WHITE}• Handle interruptions gracefully${NC}"
echo ""
echo -e "${WHITE}Press Ctrl+C to cancel, or wait 5 seconds to continue...${NC}"
sleep 5

# Execute main workflow
verify_user_setup
check_running_instances

MYSQL_PASS=$(get_mysql_credentials)

# Get initial file status
ready_files=($(monitor_downloads))

# Process any immediately ready files
if [ ${#ready_files[@]} -gt 0 ]; then
    process_ready_files "$MYSQL_PASS" "${ready_files[@]}"
fi

# If downloads are still active, start progressive monitoring
if [ "$DOWNLOADS_ACTIVE" = true ]; then
    progressive_monitor "$MYSQL_PASS"
fi

# Final check and processing
echo -e "${BLUE}[DOING NOW]: Final processing check${NC}"
ready_files=($(monitor_downloads))
new_ready=()
for file in "${ready_files[@]}"; do
    if [ ! -f "/home/maverick/.mmp/processed_${file%.csv}.flag" ]; then
        new_ready+=("$file")
    fi
done

if [ ${#new_ready[@]} -gt 0 ]; then
    process_ready_files "$MYSQL_PASS" "${new_ready[@]}"
fi

# Run normalization if all files are processed
local total_processed=$(ls /home/maverick/.mmp/processed_*.flag 2>/dev/null | wc -l)
if [ "$total_processed" -ge 3 ]; then  # Expecting at least chicago, seattle, and one LA file
    run_normalization
else
    echo -e "${ORANGE}[WARNING]: Not all files processed, skipping normalization${NC}"
    echo -e "${WHITE}You can run normalization manually later${NC}"
fi

echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  INTELLIGENT LOADING COMPLETE!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "${WHITE}Summary:${NC}"
echo -e "${GREEN}✓ Automatic user switching${NC}"
echo -e "${GREEN}✓ Conflict detection and process management${NC}"
echo -e "${GREEN}✓ Progressive file monitoring and processing${NC}"
echo -e "${GREEN}✓ City-specific table population${NC}"
if [ "$total_processed" -ge 3 ]; then
    echo -e "${GREEN}✓ Unified table normalization${NC}"
fi
echo ""
echo -e "${BLUE}Next: Run 'mmp_status' to verify all data${NC}"
echo -e "${BLUE}      Use 'mmp_unified stats' for unified data analysis${NC}"
echo -e "${BLUE}Session Manager: mmp_load --session${NC}"
echo -e "${WHITE}=============================================${NC}"

# Cleanup happens automatically via trap
```

Make it executable:

```bash
chmod +x /usr/local/bin/mmp_load
```

**Now users can:**

```bash
# After reboot/logout (as root):
mmp_load
# → Automatically switches to maverick and runs

# Check session info:
mmp_load --session

# Manual switch if preferred:
su - maverick
mmp_load
```

**Key features in this single file:**
✅ **Auto user switching** from root to maverick
✅ **Session recovery** after logout/reboot
✅ **Process conflict detection**
✅ **Progressive file monitoring** 
✅ **Complete data loading pipeline**
✅ **Automatic normalization trigger**
✅ **Session management** built-in
✅ **All v04 color scheme** maintained

This single file handles everything!

---
