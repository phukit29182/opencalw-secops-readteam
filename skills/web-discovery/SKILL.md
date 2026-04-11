---
name: web-discovery
description: การทำ Web & API Reconnaissance แบบ Jason Haddix Methodology ครอบคลุม Subdomain Enum, Live Host Discovery, Tech Fingerprint, Content & Parameter Discovery สอดคล้องกับ ISO 27001
---

# SKILL: web-discovery

## Purpose
สำรวจ Web/API attack surface แบบเจาะลึก ตั้งแต่ Subdomain Enumeration ไปจนถึง Parameter Discovery ด้วย **Jason Haddix Recon Pipeline** เป้าหมายคือส่งมอบ `all_subs.txt`, `live_hosts.txt`, `params.txt` ให้ `rt-webops` พร้อม Top 3 Attack Paths ที่ระบุ **MITRE ATT&CK T-Codes**

## Focus Areas
- **Target:** Web Services, API endpoints, Subdomains, Historical URLs
- **Frameworks:** ISO 27001 (Rules of Engagement), OWASP Top 10, MITRE ATT&CK (Reconnaissance — TA0043)
- **Tooling:** `amass`, `subfinder`, `assetfinder`, `dnsgen`, `massdns`, `httpx`, `httprobe`, `whatweb`, `nuclei`, `ffuf`, `waybackurls`, `gau`

## Required Inputs
- `base_url` / `domain`: Target หลัก
- `scope_rules`: โดเมน/pattern ที่สแกนได้
- `timebox_minutes`: เวลาสูงสุด

## Workflow

### Phase 1: Subdomain Enumeration (MITRE T1590)
```bash
# Passive multi-source enum
subfinder -d $DOMAIN -silent -o subs_subfinder.txt
assetfinder --subs-only $DOMAIN | anew subs_assetfinder.txt

# Active + permutation
amass enum -active -d $DOMAIN -o subs_amass.txt
cat subs_*.txt | sort -u | dnsgen - | massdns -r resolvers.txt -t A -o S | \
  awk '{print $1}' | sed 's/\.$//' | sort -u > all_subs.txt
```

### Phase 2: Live Host Discovery (MITRE T1590.005)
```bash
cat all_subs.txt | httpx -title -tech-detect -status-code -o live_hosts.txt
# หรือเร็วกว่าด้วย httprobe
cat all_subs.txt | httprobe --prefer-https > live_quick.txt
```

### Phase 3: Technology Fingerprinting (MITRE T1592)
```bash
whatweb -i live_hosts.txt -a 3 > tech_stack.txt
nuclei -l live_hosts.txt -t technologies/ -o tech_nuclei.txt
```

### Phase 4: Content & Parameter Discovery (MITRE T1595)
```bash
# Historical URLs
waybackurls $DOMAIN | tee wayback.txt
gau $DOMAIN | tee gau.txt

# Parameters
cat wayback.txt gau.txt | grep "=" | sort -u > params.txt

# Directory fuzzing
ffuf -ac -v -u https://$DOMAIN/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt \
  --rate-limit 50
```

## Output Contract
- `all_subs.txt` — Subdomains ทั้งหมด
- `live_hosts.txt` — Hosts ที่ตอบสนอง + tech stack
- `tech_nuclei.txt` — Technology findings
- `params.txt` — Parameters ที่พบ
- **Top 3 Attack Paths** + Confidence + MITRE T-Code

## Safety Guardrails
- ใช้ `--rate-limit` / `--threads` เสมอ ห้ามให้เกิด DoS
- จำกัด Scope ตาม `scope_rules` อย่างเคร่งครัด (ISO 27001)
- Passive-first ก่อน Active scanning

