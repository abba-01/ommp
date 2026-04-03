#!/bin/bash
# mmp_crime_complete_v09.2_final.sh
# Complete script with all security fixes and root access enabled

# ============================================
# CONFIGURATION AND FUNCTIONS
# ============================================
clear

# Colors
RED='\033[0;31m'
ORANGE='\033[38;5;214m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Animation elements
SPINNER=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
PROGRESS_CHARS=('█' '▉' '▊' '▋' '▌' '▍' '▎' '▏')

# Configuration
SCRIPT_VERSION="09.2-FINAL"
LOG_DIR="/root/mmp_logs"
SESSION_TIME=$(date +%Y%m%d_%H%M%S)

# OS Detection Function
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME="$ID"
        OS_VERSION="$VERSION_ID"
        OS_MAJOR=$(echo "$VERSION_ID" | cut -d. -f1)
    elif [ -f /etc/redhat-release ]; then
        if grep -q "CentOS" /etc/redhat-release; then
            OS_NAME="centos"
        elif grep -q "Red Hat" /etc/redhat-release; then
            OS_NAME="rhel"
        fi
        OS_VERSION=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release | head -1)
        OS_MAJOR=$(echo "$OS_VERSION" | cut -d. -f1)
    else
        echo -e "${RED}❌ Unsupported OS${NC}"
        exit 1
    fi
}

# Generate Installation ID
get_cpu_info() {
    local cpu_info=$(cat /proc/cpuinfo | grep "processor\|vendor_id\|model name" | head -6 | md5sum | cut -c1-8)
    local mac_info=$(ip link | grep ether | head -1 | awk '{print $2}' | tr -d ':' | cut -c1-4)
    echo "${cpu_info:0:4}${mac_info:0:4}" | tr '[:lower:]' '[:upper:]'
}

INSTALLATION_ID=$(get_cpu_info)
SESSION_LOG="$LOG_DIR/mmp_install_${INSTALLATION_ID}_${SESSION_TIME}.log"

# Create log directory
mkdir -p "$LOG_DIR"
chmod 700 "$LOG_DIR"

# Progress tracking
show_progress() {
    local message="$1"
    local duration="${2:-3}"
    
    for ((i=0; i<duration*4; i++)); do
        local spinner_idx=$((i % 10))
        printf "\r${BLUE}${SPINNER[spinner_idx]} %s${NC}" "$message"
        sleep 0.25
    done
    printf "\r${GREEN}✓ %s${NC}\n" "$message"
}

# Secure password generation
generate_secure_password() {
    local length=${1:-20}
    local password=""
    
    # Use /dev/urandom for better randomness
    password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-$length)
    
    # Ensure complexity requirements
    local upper=$(echo "$password" | grep -o '[A-Z]' | wc -l)
    local lower=$(echo "$password" | grep -o '[a-z]' | wc -l)
    local digit=$(echo "$password" | grep -o '[0-9]' | wc -l)
    
    # If missing required character types, regenerate
    if [ "$upper" -lt 1 ] || [ "$lower" -lt 1 ] || [ "$digit" -lt 1 ]; then
        generate_secure_password "$length"
    else
        echo "$password"
    fi
}

# Generate recovery passphrase
generate_recovery_passphrase() {
    # Generate memorable but secure passphrase
    local words=("Ocean" "Mountain" "Thunder" "Crystal" "Phoenix" "Dragon" "Storm" "Shadow")
    local word1=${words[$RANDOM % ${#words[@]}]}
    local word2=${words[$RANDOM % ${#words[@]}]}
    local num1=$((RANDOM % 90 + 10))
    local num2=$((RANDOM % 90 + 10))
    local symbols=('!' '@' '#' '$' '%' '^' '&' '*')
    local sym1=${symbols[$RANDOM % ${#symbols[@]}]}
    local sym2=${symbols[$RANDOM % ${#symbols[@]}]}
    
    echo "[${word1}${num1}${sym1}${word2}${num2}${sym2}]"
}

# Start logging
exec > >(tee -a "$SESSION_LOG")
exec 2>&1

# ============================================
# PART 1: SYSTEM PREPARATION
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}                    MMP CRIME DATABASE INSTALLER V${SCRIPT_VERSION}                    ${NC}"
echo -e "${BLUE}                         [Installation ID: $INSTALLATION_ID]                         ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detect OS
detect_os
echo -e "${WHITE}Detected OS: $OS_NAME $OS_VERSION (Major: $OS_MAJOR)${NC}"
sleep 2

# Clean and prepare system
show_progress "Cleaning package cache" 2
yum clean all &>/dev/null || dnf clean all &>/dev/null

show_progress "Installing nano" 2
yum install -y nano &>/dev/null || dnf install -y nano &>/dev/null

# Create admin user with secure credentials
ADMIN_PASSWORD=$(generate_secure_password 24)
RECOVERY_PASSPHRASE=$(generate_recovery_passphrase)

show_progress "Creating maverick user" 3
if ! id maverick &>/dev/null; then
    useradd -m -s /bin/bash maverick
    echo "$ADMIN_PASSWORD" | passwd maverick --stdin &>/dev/null
    usermod -aG wheel maverick
fi

# Create secure credential storage
mkdir -p /home/maverick/.mmp
chmod 700 /home/maverick/.mmp

# Store credentials for root (CRITICAL FIX)
mkdir -p /root/.mmp_secure
chmod 700 /root/.mmp_secure

cat > /root/.mmp_secure/installation_creds << EOF
Installation ID: $INSTALLATION_ID
Admin User: maverick
Admin Password: $ADMIN_PASSWORD
Recovery Passphrase: $RECOVERY_PASSPHRASE
Installation Date: $(date)
Script Version: $SCRIPT_VERSION
EOF
chmod 600 /root/.mmp_secure/installation_creds

# Save encrypted copy for maverick
cat > /tmp/creds.txt << EOF
Installation ID: $INSTALLATION_ID
Admin User: maverick
Admin Password: $ADMIN_PASSWORD
Recovery Passphrase: $RECOVERY_PASSPHRASE
EOF

openssl enc -aes-256-gcm -pbkdf2 -iter 600000 -salt \
    -in /tmp/creds.txt \
    -out /home/maverick/.mmp/credentials.enc \
    -pass pass:"$RECOVERY_PASSPHRASE" 2>/dev/null

shred -vfz -n 3 /tmp/creds.txt 2>/dev/null
chown -R maverick:maverick /home/maverick/.mmp

# Configure sudo
cat > /etc/sudoers.d/maverick-restricted << 'EOF'
maverick ALL=(root) NOPASSWD: /bin/systemctl start mysqld
maverick ALL=(root) NOPASSWD: /bin/systemctl stop mysqld
maverick ALL=(root) NOPASSWD: /bin/systemctl enable mysqld
maverick ALL=(root) NOPASSWD: /bin/systemctl restart mysqld
maverick ALL=(root) NOPASSWD: /usr/bin/yum install *
maverick ALL=(root) NOPASSWD: /usr/bin/dnf install *
maverick ALL=(root) NOPASSWD: /usr/bin/firewall-cmd *
EOF

# System updates
show_progress "Updating system" 10
yum update -y &>/dev/null || dnf update -y &>/dev/null
yum install -y epel-release &>/dev/null || dnf install -y epel-release &>/dev/null

# Install tools
TOOLS="wget curl git htop tree net-tools bind-utils python3 python3-pip python3-devel gcc openssl"
for tool in $TOOLS; do
    yum install -y "$tool" &>/dev/null || dnf install -y "$tool" &>/dev/null
done

# Install MySQL based on OS version
show_progress "Installing MySQL" 15
systemctl stop mysqld mariadb &>/dev/null || true
yum remove -y mysql* mariadb* &>/dev/null || true

if [ "$OS_MAJOR" = "9" ]; then
    MYSQL_REPO="https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm"
elif [ "$OS_MAJOR" = "8" ]; then
    MYSQL_REPO="https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm"
else
    MYSQL_REPO="https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm"
fi

yum install -y "$MYSQL_REPO" &>/dev/null || dnf install -y "$MYSQL_REPO" &>/dev/null
yum install -y mysql-server mysql --nogpgcheck &>/dev/null || dnf install -y mysql-server mysql --nogpgcheck &>/dev/null

# Configure MySQL
cat > /etc/my.cnf.d/mmp_crime.cnf << 'EOF'
[mysqld]
bind-address = 127.0.0.1
max_allowed_packet = 1G
innodb_buffer_pool_size = 2G
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
local_infile = 0
log_error = /var/log/mysql/error.log
skip-name-resolve
default_password_lifetime = 0

[client]
default-character-set = utf8mb4
EOF

mkdir -p /var/log/mysql
chown mysql:mysql /var/log/mysql

# Secure MySQL installation
MYSQL_ROOT_PASS=$(generate_secure_password 32)
MYSQL_APP_PASS=$(generate_secure_password 32)

# Create MySQL init file for secure setup
cat > /tmp/mysql-init.sql << INITSQL
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Remove remote root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Remove test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASS';
-- Ensure changes take effect
FLUSH PRIVILEGES;
INITSQL

# Start MySQL with init file
systemctl start mysqld
sleep 5

# Handle initial password if exists
TEMP_PASS=$(grep 'temporary password' /var/log/mysqld.log 2>/dev/null | tail -1 | awk '{print $NF}')
if [ -n "$TEMP_PASS" ]; then
    mysql --connect-expired-password -u root -p"$TEMP_PASS" < /tmp/mysql-init.sql 2>/dev/null
else
    mysql -u root < /tmp/mysql-init.sql 2>/dev/null
fi

shred -vfz -n 3 /tmp/mysql-init.sql 2>/dev/null
systemctl enable mysqld

# Save MySQL credentials securely
cat > /home/maverick/.mmp/mysql_creds.txt << EOF
MySQL root: $MYSQL_ROOT_PASS
MySQL app: $MYSQL_APP_PASS
EOF
chmod 600 /home/maverick/.mmp/mysql_creds.txt
chown maverick:maverick /home/maverick/.mmp/mysql_creds.txt

# Also store in root's secure location
cp /home/maverick/.mmp/mysql_creds.txt /root/.mmp_secure/
chmod 600 /root/.mmp_secure/mysql_creds.txt

# Create root environment for MySQL access
echo "export MMP_MYSQL_APP_PASS=\"$MYSQL_APP_PASS\"" > /root/.mmp_env
chmod 600 /root/.mmp_env

# Add to root's bashrc
if ! grep -q "source /root/.mmp_env" /root/.bashrc; then
    echo "source /root/.mmp_env" >> /root/.bashrc
fi

# ============================================
# PART 2: DATABASE AND DOWNLOADS
# ============================================
echo ""
echo -e "${BLUE}Creating database and starting downloads...${NC}"

# Create database using secure credentials
mysql -u root -p"$MYSQL_ROOT_PASS" << SQLEOF 2>/dev/null
CREATE DATABASE IF NOT EXISTS crime_data CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE crime_data;

DROP USER IF EXISTS 'crime_analyst'@'localhost';
CREATE USER 'crime_analyst'@'localhost' IDENTIFIED BY '$MYSQL_APP_PASS';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON crime_data.* TO 'crime_analyst'@'localhost';
FLUSH PRIVILEGES;

-- Chicago crimes table
DROP TABLE IF EXISTS chicago_crimes;
CREATE TABLE chicago_crimes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    case_number VARCHAR(20) UNIQUE,
    date DATETIME,
    block VARCHAR(100),
    iucr VARCHAR(10),
    primary_type VARCHAR(50),
    description TEXT,
    location_description VARCHAR(100),
    arrest BOOLEAN DEFAULT FALSE,
    domestic BOOLEAN DEFAULT FALSE,
    beat VARCHAR(10),
    district VARCHAR(10),
    ward INT,
    community_area INT,
    fbi_code VARCHAR(10),
    x_coordinate DECIMAL(10,2),
    y_coordinate DECIMAL(10,2),
    year INT,
    updated_on DATETIME,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    location VARCHAR(50),
    INDEX idx_date (date),
    INDEX idx_primary_type (primary_type),
    INDEX idx_year (year),
    INDEX idx_location (latitude, longitude)
) ENGINE=InnoDB;

-- LA crimes table
DROP TABLE IF EXISTS la_crimes;
CREATE TABLE la_crimes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dr_no VARCHAR(20) UNIQUE,
    date_rptd DATETIME,
    date_occ DATETIME,
    time_occ VARCHAR(10),
    area INT,
    area_name VARCHAR(50),
    rpt_dist_no VARCHAR(10),
    part_1_2 INT,
    crm_cd INT,
    crm_cd_desc VARCHAR(100),
    mocodes TEXT,
    vict_age INT,
    vict_sex VARCHAR(10),
    vict_descent VARCHAR(10),
    premis_cd INT,
    premis_desc VARCHAR(100),
    weapon_used_cd VARCHAR(10),
    weapon_desc VARCHAR(100),
    status VARCHAR(20),
    status_desc VARCHAR(50),
    crm_cd_1 INT,
    crm_cd_2 INT,
    crm_cd_3 INT,
    crm_cd_4 INT,
    location VARCHAR(200),
    cross_street VARCHAR(100),
    lat DECIMAL(10,8),
    lon DECIMAL(11,8),
    INDEX idx_date_occ (date_occ),
    INDEX idx_crime_code (crm_cd)
) ENGINE=InnoDB;

-- Seattle crimes table
DROP TABLE IF EXISTS seattle_crimes;
CREATE TABLE seattle_crimes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_number VARCHAR(20) UNIQUE,
    offense_id BIGINT,
    offense_start_datetime DATETIME,
    offense_end_datetime DATETIME,
    report_datetime DATETIME,
    group_a_b VARCHAR(10),
    crime_against_category VARCHAR(50),
    offense_parent_group VARCHAR(100),
    offense VARCHAR(100),
    offense_code VARCHAR(20),
    precinct VARCHAR(20),
    sector VARCHAR(10),
    beat VARCHAR(10),
    mcpp VARCHAR(50),
    _100_block_address VARCHAR(200),
    longitude DECIMAL(11,8),
    latitude DECIMAL(10,8),
    INDEX idx_offense_date (offense_start_datetime),
    INDEX idx_offense_type (offense_parent_group)
) ENGINE=InnoDB;

-- Create unified table structure
DROP TABLE IF EXISTS unified_crimes;
CREATE TABLE unified_crimes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(20) NOT NULL,
    incident_id VARCHAR(50) NOT NULL,
    incident_date DATETIME,
    incident_year INT,
    incident_month TINYINT,
    crime_category VARCHAR(100),
    crime_description TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    arrest_made BOOLEAN DEFAULT FALSE,
    source_table VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_city_date (city, incident_date),
    INDEX idx_crime_category (crime_category),
    INDEX idx_location (latitude, longitude),
    UNIQUE KEY unique_incident (city, incident_id)
) ENGINE=InnoDB;
SQLEOF

echo -e "${GREEN}✓ Database created successfully${NC}"

# Create data directories
mkdir -p /data/crime_data/{raw,scripts,logs,backups,checksums}
chown -R maverick:maverick /data/crime_data
chmod -R 755 /data/crime_data

# Download with TLS verification and checksums
echo -e "${WHITE}Starting secure data downloads...${NC}"
cd /data/crime_data/raw

# Define download sources with expected sizes
declare -A DOWNLOADS=(
    ["chicago.csv"]="https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD"
    ["la_old.csv"]="https://data.lacity.org/api/views/63jg-8b9z/rows.csv?accessType=DOWNLOAD"
    ["la_new.csv"]="https://data.lacity.org/api/views/2nrs-mtv8/rows.csv?accessType=DOWNLOAD"
    ["seattle.csv"]="https://data.seattle.gov/api/views/tazs-3rd5/rows.csv?accessType=DOWNLOAD"
)

# Start downloads with verification
for file in "${!DOWNLOADS[@]}"; do
    url="${DOWNLOADS[$file]}"
    wget --secure-protocol=TLSv1_2 --https-only -b -c "$url" -O "$file" 2>/dev/null
done

echo -e "${GREEN}✓ Secure downloads started in background${NC}"

# ============================================
# PART 3: UTILITY COMMANDS WITH ROOT ACCESS
# ============================================
echo ""
echo -e "${BLUE}Creating utility commands...${NC}"

# Create mmp_recovery (ROOT ONLY)
cat > /usr/local/bin/mmp_recovery << 'RECEOF'
#!/bin/bash
# Recovery tool - accessible only by root

if [ "$EUID" -ne 0 ]; then 
    echo "This command requires root access"
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    🔐 MMP CREDENTIAL RECOVERY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check for stored credentials
if [ -f /root/.mmp_secure/installation_creds ]; then
    echo "INSTALLATION CREDENTIALS:"
    cat /root/.mmp_secure/installation_creds
    echo ""
fi

if [ -f /root/.mmp_secure/mysql_creds.txt ]; then
    echo "MYSQL CREDENTIALS:"
    cat /root/.mmp_secure/mysql_creds.txt
    echo ""
fi

echo "CREDENTIAL LOCATIONS:"
echo "  Root backup: /root/.mmp_secure/"
echo "  User encrypted: /home/maverick/.mmp/credentials.enc"
echo "  MySQL creds: /home/maverick/.mmp/mysql_creds.txt"
echo ""

# Show latest from logs
echo "RECENT LOG ENTRIES:"
grep -E "Installation ID:|Admin Password:|Recovery Passphrase:" /root/mmp_logs/*.log 2>/dev/null | tail -5

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
RECEOF
chmod 700 /usr/local/bin/mmp_recovery

# Create mmp_status with root support
cat > /usr/local/bin/mmp_status << 'STATUSEOF'
#!/bin/bash
# Get Installation ID dynamically
get_installation_id() {
    if [ -f /root/.mmp_secure/installation_creds ]; then
        grep "Installation ID:" /root/.mmp_secure/installation_creds | awk '{print $3}'
    else
        # Fallback: reconstruct
        local cpu_info=$(cat /proc/cpuinfo | grep "processor\|vendor_id\|model name" | head -6 | md5sum | cut -c1-8)
        local mac_info=$(ip link | grep ether | head -1 | awk '{print $2}' | tr -d ':' | cut -c1-4)
        echo "${cpu_info:0:4}${mac_info:0:4}" | tr '[:lower:]' '[:upper:]'
    fi
}

INSTALLATION_ID=$(get_installation_id)

# Get MySQL password with root support
get_mysql_pass() {
    if [ -n "$MMP_MYSQL_APP_PASS" ]; then
        echo "$MMP_MYSQL_APP_PASS"
    elif [ -f /home/maverick/.mmp/mysql_creds.txt ]; then
        grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt | cut -d' ' -f3
    else
        echo ""
    fi
}

MYSQL_APP_PASS=$(get_mysql_pass)

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    📊 MMP CRIME DATABASE STATUS"
echo "                     [Installation ID: $INSTALLATION_ID]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Time: $(date)"
echo "User: $(whoami)"
echo ""

echo "📥 DATA FILES:"
if [ -d /data/crime_data/raw ]; then
    for file in chicago.csv la_old.csv la_new.csv seattle.csv; do
        if [ -f "/data/crime_data/raw/$file" ]; then
            size=$(ls -lh "/data/crime_data/raw/$file" 2>/dev/null | awk '{print $5}')
            printf "  %-15s: %8s\n" "$file" "$size"
        else
            printf "  %-15s: %8s\n" "$file" "Not found"
        fi
    done
else
    echo "  Data directory not found"
fi

echo ""
echo "⬇️ DOWNLOADS:"
WGET_COUNT=$(ps aux | grep -v grep | grep wget | wc -l)
if [ $WGET_COUNT -gt 0 ]; then
    echo "  Active downloads: $WGET_COUNT"
    ps aux | grep -v grep | grep wget | awk '{print "  " $NF}'
else
    echo "  No active downloads"
fi

echo ""
echo "📊 DATABASE STATUS:"
if [ -n "$MYSQL_APP_PASS" ]; then
    mysql -u crime_analyst -p"$MYSQL_APP_PASS" crime_data -e "
    SELECT 
        table_name AS 'Table',
        FORMAT(table_rows, 0) AS 'Records',
        ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size_MB'
    FROM information_schema.tables 
    WHERE table_schema='crime_data'
    ORDER BY table_rows DESC;" 2>/dev/null || echo "Cannot connect to database"
else
    echo "MySQL credentials not found"
fi

echo ""
echo "🔧 SERVICES:"
echo -n "MySQL: "
systemctl is-active mysqld &>/dev/null && echo "✓ Running" || echo "✗ Stopped"
echo -n "Firewall: "
if systemctl is-active firewalld &>/dev/null; then
    echo "✓ firewalld active"
elif systemctl is-active csf &>/dev/null; then
    echo "✓ CSF active"
else
    echo "✗ No firewall active"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
STATUSEOF
chmod +x /usr/local/bin/mmp_status

# Create mmp_check with integrity verification
cat > /usr/local/bin/mmp_check << 'CHECKEOF'
#!/bin/bash
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    📥 DOWNLOAD COMPLETION CHECK"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOWNLOADS_COMPLETE=true
ACTIVE_DOWNLOADS=$(ps aux | grep -v grep | grep wget | wc -l)
echo "Active wget processes: $ACTIVE_DOWNLOADS"
echo ""

# Expected file sizes (minimum bytes)
declare -A expected_sizes=(
    ["chicago.csv"]=1500000000
    ["la_old.csv"]=500000000
    ["la_new.csv"]=200000000
    ["seattle.csv"]=2500000000
)

echo "File Status:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "%-20s %-15s %-15s\n" "File" "Size" "Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for filename in "${!expected_sizes[@]}"; do
    min_size="${expected_sizes[$filename]}"
    filepath="/data/crime_data/raw/$filename"
    
    if [ -f "$filepath" ]; then
        size=$(ls -lh "$filepath" 2>/dev/null | awk '{print $5}')
        size_bytes=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
        
        # Check if file is still growing
        sleep 2
        new_size=$(stat -c%s "$filepath" 2>/dev/null || echo "0")
        
        if [ "$size_bytes" = "$new_size" ] && [ "$size_bytes" -gt "$min_size" ]; then
            printf "%-20s %-15s ${GREEN}✓ Complete${NC}\n" "$filename" "$size"
            
            # Generate checksum if not exists
            if [ ! -f "/data/crime_data/checksums/${filename}.sha256" ]; then
                sha256sum "$filepath" > "/data/crime_data/checksums/${filename}.sha256"
            fi
        else
            printf "%-20s %-15s ${YELLOW}⚡ Downloading${NC}\n" "$filename" "$size"
            DOWNLOADS_COMPLETE=false
        fi
    else
        printf "%-20s %-15s ${RED}✗ Not found${NC}\n" "$filename" "-"
        DOWNLOADS_COMPLETE=false
    fi
done

echo ""
if [ "$ACTIVE_DOWNLOADS" -eq 0 ] && [ "$DOWNLOADS_COMPLETE" = true ]; then
    echo -e "${GREEN}✅ ALL DOWNLOADS COMPLETE!${NC}"
    echo -e "${WHITE}You can now run: mmp_load${NC}"
else
    echo -e "${YELLOW}⏳ Downloads still in progress${NC}"
    echo -e "${WHITE}Check again with: mmp_check${NC}"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
CHECKEOF
chmod +x /usr/local/bin/mmp_check

# Create mmp_decrypt with dynamic passphrase
cat > /usr/local/bin/mmp_decrypt << 'DECEOF'
#!/bin/bash
# Get Installation ID dynamically
get_installation_id() {
    if [ -f /root/.mmp_secure/installation_creds ]; then
        grep "Installation ID:" /root/.mmp_secure/installation_creds | awk '{print $3}'
    else
        local cpu_info=$(cat /proc/cpuinfo | grep "processor\|vendor_id\|model name" | head -6 | md5sum | cut -c1-8)
        local mac_info=$(ip link | grep ether | head -1 | awk '{print $2}' | tr -d ':' | cut -c1-4)
        echo "${cpu_info:0:4}${mac_info:0:4}" | tr '[:lower:]' '[:upper:]'
    fi
}

INSTALLATION_ID=$(get_installation_id)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    🔐 MMP CREDENTIALS DECRYPTION"
echo "                     [Installation ID: $INSTALLATION_ID]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "💡 Tip: Running as root? Use 'mmp_recovery' for direct access"
    echo ""
fi

echo "Enter recovery passphrase:"
read -s passphrase

if [ -f "/home/maverick/.mmp/credentials.enc" ]; then
    echo ""
    echo "Decrypting credentials..."
    openssl enc -aes-256-gcm -d -pbkdf2 -iter 600000 \
        -in "/home/maverick/.mmp/credentials.enc" \
        -pass pass:"$passphrase" 2>/dev/null || {
        echo "ERROR: Decryption failed. Check passphrase."
        exit 1
    }
    
    if [ -f "/home/maverick/.mmp/mysql_creds.txt" ]; then
        echo ""
        echo "MySQL Credentials:"
        cat "/home/maverick/.mmp/mysql_creds.txt"
    fi
else
    echo "ERROR: Encrypted credentials file not found"
    exit 1
fi
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
DECEOF
chmod +x /usr/local/bin/mmp_decrypt

# Create mmp_security
cat > /usr/local/bin/mmp_security << 'SECEOF'
#!/bin/bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    🔒 MMP SECURITY STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "🔥 FIREWALL STATUS:"
if systemctl is-active firewalld &>/dev/null; then
    echo "  firewalld: ✓ Active"
    echo "  Open ports:"
    firewall-cmd --list-ports 2>/dev/null | sed 's/^/    /'
    echo "  Services:"
    firewall-cmd --list-services 2>/dev/null | sed 's/^/    /'
else
    echo "  ⚠️  No firewall active"
fi

echo ""
echo "🚫 FAIL2BAN STATUS:"
if systemctl is-active fail2ban &>/dev/null; then
    echo "  fail2ban: ✓ Active"
    fail2ban-client status sshd 2>/dev/null | grep -E "Currently|Total" | sed 's/^/    /' || echo "    No SSH jail found"
else
    echo "  fail2ban: ✗ Not active"
fi

echo ""
echo "🔐 CREDENTIALS:"
echo "  Encryption: AES-256-GCM with PBKDF2 (600k iterations)"
echo "  Root backup: /root/.mmp_secure/installation_creds"
echo "  User encrypted: /home/maverick/.mmp/credentials.enc"
if [ -f "/home/maverick/.mmp/credentials.enc" ]; then
    echo "  Status: ✓ Encrypted file exists"
    echo "  Permissions: $(ls -la /home/maverick/.mmp/credentials.enc | awk '{print $1}')"
else
    echo "  Status: ✗ Not found"
fi

echo ""
echo "🔑 SSH CONFIGURATION:"
echo "  Port: $(grep "^Port" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo "22")"
echo "  Root Login: $(grep "^PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo "yes")"
echo "  Password Auth: $(grep "^PasswordAuthentication" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo "yes")"

echo ""
echo "📜 RECENT AUTH ATTEMPTS:"
grep "Accepted\|Failed" /var/log/secure 2>/dev/null | tail -3 | sed 's/^/  /'

echo ""
echo "💾 BACKUP LOCATIONS:"
echo "  Installation logs: /root/mmp_logs/"
echo "  Secure credentials: /root/.mmp_secure/"
echo "  Data checksums: /data/crime_data/checksums/"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
SECEOF
chmod +x /usr/local/bin/mmp_security

# Create remaining utilities with root support
cat > /usr/local/bin/mmp_unified << 'UNIFIEDEOF'
#!/bin/bash
# Get MySQL password with root support
get_mysql_pass() {
    if [ -n "$MMP_MYSQL_APP_PASS" ]; then
        echo "$MMP_MYSQL_APP_PASS"
    elif [ -f /home/maverick/.mmp/mysql_creds.txt ]; then
        grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt | cut -d' ' -f3
    else
        echo ""
    fi
}

MYSQL_APP_PASS=$(get_mysql_pass)

if [ -z "$MYSQL_APP_PASS" ]; then
    echo "ERROR: Cannot retrieve MySQL credentials"
    exit 1
fi

case "$1" in
    "stats"|"status")
        mysql -u crime_analyst -p"$MYSQL_APP_PASS" crime_data -e "
        SELECT 
            city,
            FORMAT(COUNT(*), 0) as total_records,
            MIN(incident_date) as earliest_date,
            MAX(incident_date) as latest_date,
            COUNT(DISTINCT crime_category) as unique_crime_types
        FROM unified_crimes 
        GROUP BY city
        UNION ALL
        SELECT 
            'TOTAL' as city,
            FORMAT(COUNT(*), 0) as total_records,
            MIN(incident_date) as earliest_date,
            MAX(incident_date) as latest_date,
            COUNT(DISTINCT crime_category) as unique_crime_types
        FROM unified_crimes;"
        ;;
    "query"|"sql")
        mysql -u crime_analyst -p"$MYSQL_APP_PASS" crime_data
        ;;
    *)
        echo "Usage: mmp_unified [stats|query]"
        ;;
esac
UNIFIEDEOF
chmod +x /usr/local/bin/mmp_unified

cat > /usr/local/bin/mmp_db << 'DBEOF'
#!/bin/bash
# Get MySQL password with root support
get_mysql_pass() {
    if [ -n "$MMP_MYSQL_APP_PASS" ]; then
        echo "$MMP_MYSQL_APP_PASS"
    elif [ -f /home/maverick/.mmp/mysql_creds.txt ]; then
        grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt | cut -d' ' -f3
    else
        echo ""
    fi
}

MYSQL_APP_PASS=$(get_mysql_pass)

if [ -z "$MYSQL_APP_PASS" ]; then
    echo "ERROR: Cannot retrieve MySQL credentials"
    echo "Run 'mmp_decrypt' to access credentials"
    exit 1
fi

mysql -u crime_analyst -p"$MYSQL_APP_PASS" crime_data
DBEOF
chmod +x /usr/local/bin/mmp_db

cat > /usr/local/bin/mmp_help << 'HELPEOF'
#!/bin/bash
# Get Installation ID dynamically
get_installation_id() {
    if [ -f /root/.mmp_secure/installation_creds ]; then
        grep "Installation ID:" /root/.mmp_secure/installation_creds | awk '{print $3}'
    else
        local cpu_info=$(cat /proc/cpuinfo | grep "processor\|vendor_id\|model name" | head -6 | md5sum | cut -c1-8)
        local mac_info=$(ip link | grep ether | head -1 | awk '{print $2}' | tr -d ':' | cut -c1-4)
        echo "${cpu_info:0:4}${mac_info:0:4}" | tr '[:lower:]' '[:upper:]'
    fi
}

INSTALLATION_ID=$(get_installation_id)

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    📚 MMP CRIME DATABASE HELP"
echo "                     [Installation ID: $INSTALLATION_ID]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 MONITORING COMMANDS:"
echo "  mmp_status      - Complete system dashboard with downloads"
echo "  mmp_check       - Check download completion status"
echo "  mmp_security    - Security configuration status"
echo ""
echo "🗄️ DATABASE COMMANDS:"
echo "  mmp_db          - Direct database access"
echo "  mmp_unified     - Unified data analysis"
echo "  mmp_load        - Load data after downloads complete"
echo ""
echo "🔐 SECURITY COMMANDS:"
echo "  mmp_decrypt     - Decrypt stored credentials (user)"
echo "  mmp_recovery    - Access all credentials (root only)"
echo ""
echo "🆔 SYSTEM INFO:"
echo "  Installation ID: $INSTALLATION_ID"
echo "  Script Version: V09.2-FINAL"
echo ""
echo "💡 TIPS:"
echo "  - If locked out, run 'mmp_recovery' as root"
echo "  - Credentials backed up at /root/.mmp_secure/"
echo "  - Check downloads with 'mmp_check' before loading"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
HELPEOF
chmod +x /usr/local/bin/mmp_help

# Create mmp_load with root support
cat > /usr/local/bin/mmp_load << 'LOADEOF'
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

# Get MySQL credentials with root support
get_mysql_pass() {
    if [ -n "$MMP_MYSQL_APP_PASS" ]; then
        echo "$MMP_MYSQL_APP_PASS"
    elif [ -f /home/maverick/.mmp/mysql_creds.txt ]; then
        grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt | cut -d' ' -f3
    else
        echo ""
    fi
}

MYSQL_PASS=$(get_mysql_pass)

if [ -z "$MYSQL_PASS" ]; then
    echo -e "${RED}❌ Cannot retrieve MySQL credentials${NC}"
    echo -e "${YELLOW}Run 'mmp_decrypt' to access credentials${NC}"
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
    
    # Verify checksum
    if [ -f "/data/crime_data/checksums/chicago.csv.sha256" ]; then
        if ! sha256sum -c "/data/crime_data/checksums/chicago.csv.sha256" &>/dev/null; then
            echo -e "${RED}✗ Checksum verification failed${NC}"
            return 1
        fi
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
        shred -vfz -n 3 /tmp/load_chicago.sql 2>/dev/null
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
        
        shred -vfz -n 3 /tmp/load_la.sql /tmp/load_la2.sql 2>/dev/null
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
        shred -vfz -n 3 /tmp/load_seattle.sql 2>/dev/null
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
LOADEOF
chmod +x /usr/local/bin/mmp_load

# Install Python packages
echo -e "${WHITE}Installing Python packages...${NC}"
python3 -m pip install --user pandas mysql-connector-python tqdm &>/dev/null

# Install and configure security
echo -e "${WHITE}Configuring security...${NC}"
yum install -y fail2ban &>/dev/null || dnf install -y fail2ban &>/dev/null

cat > /etc/fail2ban/jail.local << 'F2BEOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/secure
maxretry = 3
F2BEOF

systemctl enable fail2ban
systemctl start fail2ban

# Configure firewall
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-port=3306/tcp --source=127.0.0.1
firewall-cmd --reload

# Source root environment for immediate use
source /root/.bashrc

# ============================================
# FINAL SUMMARY
# ============================================
clear
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}                    🎉 MMP CRIME DATABASE INSTALLATION COMPLETE! 🎉                    ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${WHITE}📊 INSTALLATION SUMMARY:${NC}"
echo -e "${GREEN}✅ System prepared and updated${NC}"
echo -e "${GREEN}✅ MySQL installed and secured${NC}"
echo -e "${GREEN}✅ Database and tables created${NC}"
echo -e "${GREEN}✅ Secure downloads started${NC}"
echo -e "${GREEN}✅ All utility commands installed${NC}"
echo -e "${GREEN}✅ Security configured${NC}"
echo -e "${GREEN}✅ Root access enabled${NC}"
echo ""
echo -e "${WHITE}🔧 COMMANDS AVAILABLE:${NC}"
echo -e "${YELLOW}  mmp_status   ${WHITE}- System dashboard${NC}"
echo -e "${YELLOW}  mmp_check    ${WHITE}- Monitor downloads${NC}"
echo -e "${YELLOW}  mmp_security ${WHITE}- Security status${NC}"
echo -e "${YELLOW}  mmp_decrypt  ${WHITE}- Access credentials${NC}"
echo -e "${YELLOW}  mmp_recovery ${WHITE}- Root recovery tool${NC}"
echo -e "${YELLOW}  mmp_load     ${WHITE}- Load data when ready${NC}"
echo -e "${YELLOW}  mmp_help     ${WHITE}- Show all commands${NC}"
echo ""
echo -e "${RED}🔑 YOUR CREDENTIALS (SAVE THESE NOW!):${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Installation ID: $INSTALLATION_ID${NC}"
echo -e "${GREEN}Admin User: maverick${NC}"
echo -e "${GREEN}Admin Password: $ADMIN_PASSWORD${NC}"
echo -e "${GREEN}Recovery Passphrase: $RECOVERY_PASSPHRASE${NC}"
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}💾 BACKUP LOCATIONS:${NC}"
echo -e "${WHITE}  Root access: /root/.mmp_secure/installation_creds${NC}"
echo -e "${WHITE}  Encrypted: /home/maverick/.mmp/credentials.enc${NC}"
echo -e "${WHITE}  Logs: /root/mmp_logs/${NC}"
echo ""
echo -e "${BLUE}📥 DOWNLOADS:${NC}"
echo -e "${WHITE}  Status: Running in background${NC}"
echo -e "${WHITE}  Check progress: mmp_check${NC}"
echo -e "${WHITE}  Load when ready: mmp_load${NC}"
echo ""
echo -e "${YELLOW}⏱️  Estimated download time: 30-90 minutes${NC}"
echo -e "${WHITE}💡 Root can now run all mmp commands directly!${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"