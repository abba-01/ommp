# Linux Download and Database Script Debugging
**Date:** 2025-07-04  
**Messages:** 4  
**UUID:** 6f80bf72-04e2-425e-a326-d433e184ed1d

---

**UNKNOWN**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📥 DOWNLOAD COMPLETION CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Active wget processes: 0
File Status:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File                 Size            Status         
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
chicago.csv          1.9G            ✓ Complete
la_old.csv           515M            ✓ Complete
la_new.csv           244M            ✓ Complete
seattle.csv          3.2G            ✓ Complete
✅ ALL DOWNLOADS COMPLETE!
You can now run: mmp_load
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@one ~]# mmp_load
------
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📊 MMP CRIME DATABASE STATUS
                     [Installation ID: 98A9BAC1]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Time: Fri Jul  4 10:53:40 PM UTC 2025
User: root
📥 DATA FILES:
  chicago.csv    :     1.9G
  la_old.csv     :     515M
  la_new.csv     :     244M
  seattle.csv    :     3.2G
⬇️ DOWNLOADS:
  No active downloads
📊 DATABASE STATUS:
Cannot connect to database
🔧 SERVICES:
MySQL: ✓ Running
Firewall: ✓ firewalld active
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@one ~]# 
-----
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📚 MMP CRIME DATABASE HELP
                     [Installation ID: 98A9BAC1]
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
  Installation ID: 98A9BAC1
  Recovery: Use passphrase with mmp_decrypt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@one ~]# 
______
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📚 MMP CRIME DATABASE HELP
                     [Installation ID: 98A9BAC1]
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
  Installation ID: 98A9BAC1
  Recovery: Use passphrase with mmp_decrypt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@one ~]# mmp_security
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    🔒 MMP SECURITY STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔥 FIREWALL STATUS:
  firewalld: ✓ Active
  Open ports:
    
  Services:
    cockpit dhcpv6-client ssh
🚫 FAIL2BAN STATUS:
  fail2ban: ✓ Active
    |  |- Currently failed:     0
    |  |- Total failed: 1
       |- Currently banned:     0
       |- Total banned: 0
🔐 CREDENTIALS:
  Encryption: AES-256-GCM with PBKDF2
  Location: /home/maverick/.mmp/credentials.enc
  Status: ✓ Exists
  Permissions: -rw-------.
🔑 SSH CONFIGURATION:
  Port: 
  Root Login: yes
  Password Auth: no
📜 RECENT AUTH ATTEMPTS:
  Jul  4 22:01:17 localhost sshd[14400]: Accepted publickey for root from 162.243.188.66 port 42649 ssh2: ECDSA SHA256:gvjLXpPkxrufwpdHKOkSm+ZXZCwVveI/gu3prnAUHiw
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[root@one ~]# 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    📊 MMP DATA LOADING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All files downloaded. Starting data load...
❌ Cannot connect to database
[root@one ~]# dir
go.sh  mmp_logs  mmp_streamlined_v09.sh
[root@one ~]# nano go.sh
[root@one ~]# history
    1  yum install nano -y
    2  nano one.sh
    3  rename one.sh mmp_streamlined_v09.sh
    4  cp one.sh mmp_streamlined_v09.sh
    5  rm  one.sh
    6  chmod +x mmp_streamlined_v09.sh
    7  ./mmp_streamlined_v09.sh
    8  mmp_status
    9  nano  one.sh mmp_streamlined_v09.sh
   10   rmmmp_streamlined_v09.sh
   11  nano go.sh
   12  chomd +x go.sh
   13  ./go.sh
   14  chmod +x go.sh
   15  ./go.sh
   16  rm go.sh
   17  nano go.sh
   18  chmod +x go.sh
   19  ./go.sh
   20  mmp_check
   21  mmp_status
   22  mmp_help
   23  mmp_check
   24  mmp_load
   25  dir
   26  nano go.sh
   27  history
[root@one ~]#

---
**UNKNOWN**


Looking at your debug output, I've identified the issue. The `mmp_load` command is failing to connect to the database because of a credential retrieval problem.

## The Problem

- All downloads completed successfully (correct file sizes shown)
- MySQL is running 
- But `mmp_load` can't connect to the database
- The issue: `mmp_load` tries to read MySQL credentials from a file that has restrictive permissions

## Quick Fix

Here's a corrected version of `mmp_load` that embeds the credentials like the other commands:

OK

## To Apply the Fix:

1. **Replace the broken mmp_load command:**
```bash
# Backup the old one
mv /usr/local/bin/mmp_load /usr/local/bin/mmp_load.broken

# Create the new one
nano /usr/local/bin/mmp_load
```

2. **Copy the entire fixed script from the artifact above into the nano editor**

3. **Save and make executable:**
```bash
chmod +x /usr/local/bin/mmp_load
```

4. **Run the fixed loader:**
```bash
mmp_load
```

When prompted, enter the recovery passphrase that was shown during installation:
`[Ocean47$Mountain82@RT!]`

## Alternative Quick Fix

If you want an even simpler fix, you can check what MySQL password was generated by running:
```bash
sudo -u maverick cat /home/maverick/.mmp/mysql_creds.txt
```

Then manually update the mmp_load script to embed that password directly instead of trying to read it from the file.

## Why This Happened

The installation script has an inconsistency:
- Commands like `mmp_status` embed the MySQL password directly in the script
- But `mmp_load` tries to read it from a file owned by the `maverick` user
- When running as `root`, it can't read that file due to permissions

The fixed version properly handles credential decryption and retrieval.

---
**UNKNOWN**

I had logged out and logged back in - i needa away back in run through the sccript again wlaidiating fucntions andstuff formaverick user amoutn sum vs teh required sum for all known commands less the first from root

---
**UNKNOWN**


I'll help you create a validation script to check all the MMP commands and their functionality, especially for the maverick user. Here's a comprehensive validation script:

OK

Now let me create a command checksum validator that specifically handles the maverick user validation:

OK

Here's how to use these validation scripts:

## 1. First, save the validation scripts:

```bash
# Save the main validator
nano /usr/local/bin/mmp_validate
# Copy the first script content, save and exit

# Save the checksum validator  
nano /usr/local/bin/mmp_checksum
# Copy the second script content, save and exit

# Make them executable
chmod +x /usr/local/bin/mmp_validate
chmod +x /usr/local/bin/mmp_checksum
```

## 2. Run validation as root first:

```bash
mmp_validate
mmp_checksum
```

## 3. Get the maverick password and switch users:

```bash
# Get the maverick password first
grep "Admin Password:" /root/mmp_logs/mmp_install_*.log | tail -1

# Or decrypt it
mmp_decrypt
# Enter the recovery passphrase: [Ocean47$Mountain82@RT!]

# Switch to maverick user
su - maverick
```

## 4. Run validation as maverick:

```bash
# As maverick user:
mmp_validate
mmp_checksum

# Test specific commands
mmp_help
mmp_status
mmp_check
```

## 5. Quick command to check all mmp commands:

```bash
# List all mmp commands with details
ls -la /usr/local/bin/mmp_* | awk '{print $1, $3, $4, $5, $9}'

# Count them
ls -1 /usr/local/bin/mmp_* | wc -l

# Get total size (the "sum")
du -cb /usr/local/bin/mmp_* | grep total
```

## 6. If you need to fix the mmp_load issue:

```bash
# As root, apply the fix from my previous response
mv /usr/local/bin/mmp_load /usr/local/bin/mmp_load.broken
nano /usr/local/bin/mmp_load
# Paste the fixed version
chmod +x /usr/local/bin/mmp_load
```

The validation scripts will show you:
- Which commands exist and are executable
- File permissions and ownership  
- Whether maverick user has proper access
- Database connectivity status
- A total checksum/size validation
- Specific recommendations for any issues found

This should give you a complete picture of the system state after logging back in.

---
