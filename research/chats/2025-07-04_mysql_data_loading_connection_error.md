# MySQL Data Loading Connection Error
**Date:** 2025-07-04  
**Messages:** 14  
**UUID:** c73324ea-6f86-49cc-bf17-8d974ca750ec

---

**UNKNOWN**

the user maverick is supposed to be persistent and gracefully recoveredf om faulre. I instalqed ervtyhign up untilmerging thetables through normalization bt wheen it went to go intot he mysql and normalizae i got this error: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

 I see the issue. The `mmp_load` command is trying to connect to the database but failing. This is likely because:

1. The MySQL credentials aren't being read correctly
2. The MySQL service might not be running
3. The user permissions might not be set up properly

Let's create a diagnostic and recovery script to fix this:

```bash
#!/bin/bash
# mmp_fix_db.sh - Database connection recovery script

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}                    🔧 MMP DATABASE CONNECTION RECOVERY                    ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Step 1: Check MySQL service
echo -e "${YELLOW}Checking MySQL service...${NC}"
if systemctl is-active mysqld &>/dev/null; then
    echo -e "${GREEN}✓ MySQL is running${NC}"
else
    echo -e "${RED}✗ MySQL is not running${NC}"
    echo -e "${YELLOW}Starting MySQL...${NC}"
    systemctl start mysqld
    sleep 3
    if systemctl is-active mysqld &>/dev/null; then
        echo -e "${GREEN}✓ MySQL started successfully${NC}"
    else
        echo -e "${RED}✗ Failed to start MySQL${NC}"
        echo "Checking error log..."
        tail -20 /var/log/mysqld.log 2>/dev/null || tail -20 /var/log/mysql/error.log 2>/dev/null
        exit 1
    fi
fi

# Step 2: Check if credentials file exists
echo -e "\n${YELLOW}Checking credentials...${NC}"
if [ -f "/home/maverick/.mmp/mysql_creds.txt" ]; then
    echo -e "${GREEN}✓ Credentials file exists${NC}"
    
    # Try to extract passwords
    MYSQL_ROOT_PASS=$(grep "MySQL root:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)
    MYSQL_APP_PASS=$(grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)
    
    if [ -z "$MYSQL_ROOT_PASS" ] || [ -z "$MYSQL_APP_PASS" ]; then
        echo -e "${RED}✗ Cannot read passwords from credentials file${NC}"
        echo -e "${YELLOW}Attempting recovery...${NC}"
    else
        echo -e "${GREEN}✓ Passwords retrieved${NC}"
    fi
else
    echo -e "${RED}✗ Credentials file not found${NC}"
    echo -e "${YELLOW}Will attempt to reset passwords...${NC}"
fi

# Step 3: Test database connection
echo -e "\n${YELLOW}Testing database connection...${NC}"
if [ -n "$MYSQL_APP_PASS" ]; then
    if mysql -u crime_analyst -p"$MYSQL_APP_PASS" crime_data -e "SELECT 1;" &>/dev/null; then
        echo -e "${GREEN}✓ Database connection successful!${NC}"
        
        # Fix the mmp_load command with the correct password
        echo -e "\n${YELLOW}Updating mmp_load with correct credentials...${NC}"
        sed -i "s/grep \"MySQL app:\"/grep 'MySQL app:'/g" /usr/local/bin/mmp_load
        echo -e "${GREEN}✓ mmp_load updated${NC}"
        
        # Also update other commands
        for cmd in mmp_status mmp_unified mmp_db; do
            if [ -f "/usr/local/bin/$cmd" ]; then
                # Replace the password in the file
                sed -i "s/-p'[^']*' crime_data/-p'$MYSQL_APP_PASS' crime_data/g" "/usr/local/bin/$cmd"
                echo -e "${GREEN}✓ Updated $cmd${NC}"
            fi
        done
        
        echo -e "\n${GREEN}✅ Database connection recovered! You can now run mmp_load${NC}"
        exit 0
    else
        echo -e "${RED}✗ Connection failed with stored password${NC}"
    fi
fi

# Step 4: Reset MySQL passwords if needed
echo -e "\n${YELLOW}Attempting password reset...${NC}"
echo -e "${RED}This requires stopping MySQL temporarily${NC}"
read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Stop MySQL
systemctl stop mysqld

# Start MySQL with skip-grant-tables
echo -e "${YELLOW}Starting MySQL in recovery mode...${NC}"
mysqld_safe --skip-grant-tables --skip-networking &
MYSQL_PID=$!
sleep 5

# Generate new passwords
NEW_ROOT_PASS=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-20)
NEW_APP_PASS=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-20)

# Reset passwords
mysql << EOF 2>/dev/null
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_ROOT_PASS';
ALTER USER 'crime_analyst'@'localhost' IDENTIFIED BY '$NEW_APP_PASS';
FLUSH PRIVILEGES;
EOF

# Kill the recovery MySQL
kill $MYSQL_PID 2>/dev/null
sleep 3

# Start MySQL normally
systemctl start mysqld

# Save new credentials
echo "MySQL root: $NEW_ROOT_PASS" > /home/maverick/.mmp/mysql_creds.txt
echo "MySQL app: $NEW_APP_PASS" >> /home/maverick/.mmp/mysql_creds.txt
chmod 600 /home/maverick/.mmp/mysql_creds.txt
chown maverick:maverick /home/maverick/.mmp/mysql_creds.txt

# Update all commands with new password
for cmd in mmp_status mmp_unified mmp_db mmp_load; do
    if [ -f "/usr/local/bin/$cmd" ]; then
        sed -i "s/-p'[^']*' crime_data/-p'$NEW_APP_PASS' crime_data/g" "/usr/local/bin/$cmd"
        echo -e "${GREEN}✓ Updated $cmd with new password${NC}"
    fi
done

echo -e "\n${GREEN}✅ MySQL passwords reset successfully!${NC}"
echo -e "${YELLOW}New credentials saved to /home/maverick/.mmp/mysql_creds.txt${NC}"
echo -e "${BLUE}You can now run mmp_load${NC}"
```

Save this as `/usr/local/bin/mmp_fix_db` and make it executable:

```bash
chmod +x /usr/local/bin/mmp_fix_db
```

Then run it:
```bash
mmp_fix_db
```

This script will:
1. Check if MySQL is running
2. Try to retrieve and test the existing passwords
3. Update the commands with the correct password
4. If that fails, offer to reset the MySQL passwords
5. Update all the mmp commands with the new passwords

After running this fix script, you should be able to run `mmp_load` successfully.

---
**UNKNOWN**

no. read teh script adn figure out whare the script forgets the password. it shoudl be kept persistern inthe ijnstallation session

---
**UNKNOWN**

 You're absolutely right! Looking at the script, I found the issue. The script generates passwords and saves them, but the `mmp_load` command tries to read them dynamically and fails. The problem is in how `mmp_load` retrieves the password.

In the script, the passwords are generated as:
```bash
MYSQL_APP_PASS=$(generate_stig_password 24)
```

And saved to the file as:
```bash
echo "MySQL app: $MYSQL_APP_PASS" >> /home/maverick/.mmp/mysql_creds.txt
```

But in `mmp_load`, it tries to read the password dynamically:
```bash
MYSQL_PASS=$(grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)
```

The issue is that when creating `mmp_load` and other commands, the script should embed the actual password value, not try to read it later. Here's the fix - when creating the commands, the password should be embedded directly:

Instead of:
```bash
cat > /usr/local/bin/mmp_status << EOF
...
mysql -u crime_analyst -p'$MYSQL_APP_PASS' crime_data -e "
```

The script correctly embeds `$MYSQL_APP_PASS` because it's inside `<< EOF` (not `<< 'EOF'`), so the variable is expanded.

The real issue is in `mmp_load` which uses `<< 'EOF'` (quoted EOF), preventing variable expansion:

```bash
cat > /usr/local/bin/mmp_load << 'EOF'
```

This means the line:
```bash
MYSQL_PASS=$(grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)
```

Is trying to read the password at runtime, but it might fail due to permissions or file access issues.

The fix is to change the `mmp_load` creation to use unquoted EOF for the sections that need the password:

```bash
# Create mmp_load with embedded password
cat > /usr/local/bin/mmp_load << EOF
#!/bin/bash
# mmp_load - Load crime data CSV files into MySQL database
# Password embedded at installation time
MYSQL_PASS='$MYSQL_APP_PASS'
EOF

# Then continue with the rest using quoted EOF for the parts that don't need variable expansion
cat >> /usr/local/bin/mmp_load << 'EOF'
# Rest of the script...
```

This way, the actual password value is embedded in the script at installation time, making it persistent and avoiding the need to read from files later.

---
**UNKNOWN**

i think its exncrypoted to

---
**UNKNOWN**

 You're absolutely right! Looking at the script more carefully, I see the issue. The credentials are saved in two places:

1. **Encrypted** in `/home/maverick/.mmp/credentials.enc` (contains Installation ID, Admin User, Admin Password, and Recovery passphrase)
2. **Plain text** in `/home/maverick/.mmp/mysql_creds.txt` (contains MySQL passwords)

The MySQL credentials are saved here:
```bash
# Save MySQL credentials
echo "MySQL root: $MYSQL_ROOT_PASS" >> /home/maverick/.mmp/mysql_creds.txt
echo "MySQL app: $MYSQL_APP_PASS" >> /home/maverick/.mmp/mysql_creds.txt
chmod 600 /home/maverick/.mmp/mysql_creds.txt
chown maverick:maverick /home/maverick/.mmp/mysql_creds.txt
```

But when `mmp_load` tries to read them:
```bash
MYSQL_PASS=$(grep "MySQL app:" /home/maverick/.mmp/mysql_creds.txt 2>/dev/null | cut -d' ' -f3)
```

The issue is likely that:
1. You're running as `root` but the file is owned by `maverick` with 600 permissions
2. Or the file path isn't accessible

The real fix is that the script should embed the password directly into the commands at installation time. Look at how `mmp_status`, `mmp_unified`, and `mmp_db` are created - they have the password embedded:

```bash
cat > /usr/local/bin/mmp_db << EOF
#!/bin/bash
mysql -u crime_analyst -p'$MYSQL_APP_PASS' crime_data
EOF
```

But `mmp_load` uses quoted EOF (`<< 'EOF'`) which prevents variable expansion, so it tries to read the password at runtime instead of embedding it.

The fix is to modify the script to embed the password in `mmp_load` at installation time, just like the other commands do. The password should be `$MYSQL_APP_PASS` and should be embedded when the script is created, not read from a file later.

---
**UNKNOWN**

yES, i NEEDE DYOU TO SEE THAT i RWECOVERED FROM A FILURE OR REBOOT. IM BACK IN TEH SYSTEM AS ROOT. hOW DO i GET BACK INTO MAVERCIK WIHTOUTSTHE USERNAME APASSWRD

---
**UNKNOWN**

 Since you're root and need to get back into the maverick account without the password, here are your options:

## Option 1: Reset maverick's password as root
```bash
passwd maverick
```
Enter a new password twice. This is the simplest approach.

## Option 2: Switch to maverick without a password (as root)
```bash
su - maverick
```
As root, you don't need a password to switch to any user.

## Option 3: Recover the original password
The original admin password is stored encrypted. Use the recovery passphrase:
```bash
# The recovery passphrase is: [Ocean47$Mountain82@RT!]
mmp_decrypt
```
When prompted, enter: `[Ocean47$Mountain82@RT!]`

This should show you the original credentials including the maverick password.

## Option 4: If mmp_decrypt doesn't work, decrypt manually
```bash
openssl enc -aes-256-gcm -d -pbkdf2 -iter 600000 \
    -in /home/maverick/.mmp/credentials.enc \
    -pass pass:'[Ocean47$Mountain82@RT!]'
```

## Option 5: Check the installation log
The installation saved a log with the credentials:
```bash
ls -la /root/mmp_logs/
cat /root/mmp_logs/mmp_install_*
```
Look for the section with "Admin Password:" in the log file.

The quickest option is just `su - maverick` since you're already root.

---
**UNKNOWN**

wheer di you get the decryption jkey is that secret to us?

---
**UNKNOWN**

 No, the recovery passphrase is NOT secret! Looking at the script, it's hardcoded right there in plain text:

```bash
RECOVERY_PASSPHRASE="[Ocean47\$Mountain82@RT!]"
```

This is defined early in the script and then:
1. Used to encrypt the credentials
2. Shown to you in the final output screen
3. Saved in the encrypted file itself

At the end of the installation, the script displays:
```
echo -e "${GREEN}Recovery Passphrase: $RECOVERY_PASSPHRASE${NC}"
```

So the recovery passphrase `[Ocean47$Mountain82@RT!]` is:
- Hardcoded in the script
- The same for every installation
- Shown to you during installation
- Meant to be saved by you

This is actually a security weakness - having a hardcoded recovery passphrase that's the same for everyone who runs this script. In a production system, this should be randomly generated like the passwords are.

The script shows you all the credentials at the end and tells you to "SAVE THESE CREDENTIALS SECURELY!" - including this recovery passphrase.

---
**UNKNOWN**

yess, put anote. i believbits just a placehoolder. i told themt o put that logic in. make sure we annotae that in teh header of the script. for now. lets leave the system as is. lets see if the recoverys tsem even qworks. how do i do it

---
**UNKNOWN**

 You're right, let's test the recovery system. Since you're logged in as root, here's how to test the recovery:

## Test the Recovery System:

### 1. First, try the mmp_decrypt command:
```bash
mmp_decrypt
```
When it asks for the recovery passphrase, enter:
```
[Ocean47$Mountain82@RT!]
```

### 2. If that doesn't work (command not found), try manual decryption:
```bash
openssl enc -aes-256-gcm -d -pbkdf2 -iter 600000 \
    -in /home/maverick/.mmp/credentials.enc \
    -pass pass:'[Ocean47$Mountain82@RT!]'
```

### 3. Also check if the MySQL credentials file exists:
```bash
cat /home/maverick/.mmp/mysql_creds.txt
```

### 4. To test the full recovery, switch to maverick without password:
```bash
su - maverick
```

Then try running:
```bash
mmp_status
mmp_check
```

Let me know what happens with each step. This will tell us if the recovery system is working as designed.

And yes, we should add a note at the script header about the hardcoded recovery passphrase being a placeholder that should be changed in production. Something like:

```bash
# ============================================
# SECURITY NOTE: 
# The RECOVERY_PASSPHRASE is hardcoded as a placeholder.
# In production, this should be randomly generated or 
# provided by the user during installation.
# Current placeholder: [Ocean47$Mountain82@RT!]
# ============================================
```

---
**UNKNOWN**

Recovery: Use passphrase with mmp_decrypt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@two ~]# mmp_load
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📊 MMP DATA LOADING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All files downloaded. Starting data load...
❌ Cannot connect to database
[root@two ~]# mmp_decrypt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    🔐 MMP CREDENTIALS DECRYPTION
                     [Installation ID: 98A90AC8]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Enter recovery passphrase:
ERROR: Encrypted credentials file not found
[root@two ~]#

---
**UNKNOWN**

 The recovery system is failing because the encrypted credentials file doesn't exist. Let's diagnose this:

## 1. Check if the directory and files exist:
```bash
ls -la /home/maverick/.mmp/
```

## 2. Look for the credentials in other locations:
```bash
find /home -name "credentials.enc" 2>/dev/null
find /root -name "credentials.enc" 2>/dev/null
```

## 3. Check if the mysql_creds.txt exists:
```bash
ls -la /home/maverick/.mmp/mysql_creds.txt
cat /home/maverick/.mmp/mysql_creds.txt
```

## 4. Check the installation logs for the original passwords:
```bash
ls -la /root/mmp_logs/
# Look for your installation log
grep -i "password" /root/mmp_logs/mmp_install_*.log | tail -20
```

## 5. Check if MySQL is running and try to connect:
```bash
systemctl status mysqld
```

## 6. Since the encrypted file is missing but you need to recover, let's check what users exist:
```bash
mysql -u root -e "SELECT user, host FROM mysql.user;"
```
(This will probably ask for a password we don't have)

The issue seems to be that the installation didn't complete properly or files were lost during the reboot. The quickest fix might be to:

1. First see what files actually exist with the commands above
2. Then we can either recover from logs or reset the MySQL passwords

What output do you get from the `ls -la /home/maverick/.mmp/` command?

---
