# Skills Index (Web/API, MITRE ATT&CK & ISO 27001 Ready)

เอกสารนี้รวบรวมและจัดจำแนกชาร์ต `scenario -> skills` ให้ทาง Trainers และ `rt-lead` สามารถใช้งานเครื่องมือบน **Kali Linux** ภายใต้มาตรฐาน **OWASP Top 10**, **MITRE ATT&CK** และ **ISO 27001**.

## Scenario -> Skills

| Scenario | Recon Skills | Exploit Skills (WebOps) | Access Skills | Debrief Skills |
|----------|--------------|-------------------------|---------------|----------------|
| `web-lab-sqli-basic` | `web-discovery`, `network-recon` | `sql-injection-union`, `sql-injection-error`, `sql-injection-blind` | `priv-escalation` | `retrospective` |
| `web-lab-authz-bypass` | `web-discovery`, `network-recon` | `idor`, `jwt-auth` | `lateral-movement` | `retrospective` |
| `web-lab-ssrf-pivot` | `web-discovery`, `network-recon` | `ssrf` | `lateral-movement` | `retrospective` |
| `web-lab-client-attacks`| `web-discovery`, `network-recon` | `xss` | — | `retrospective` |
| `api-lab-mass-assign` | `web-discovery` | `mass-assignment`, `bfla` | `priv-escalation` | `retrospective` |
| `api-lab-rate-limit` | `web-discovery` | `rate-limit-bypass` | — | `retrospective` |
| `api-lab-schema-abuse` | `web-discovery` | `api-schema-validation`, `mass-assignment` | — | `retrospective` |
| `api-lab-graphql` | `web-discovery`, `graphql-introspection` | `bfla`, `idor` | `lateral-movement` | `retrospective` |

## Agent -> Skills

| Agent | Core Focus | Skills ที่ใช้หลัก |
|-------|------------|-------------------|
| `rt-recon` | Jason Haddix Recon Pipeline, Subdomain/Live Host/Param Discovery | `web-discovery`, `network-recon`, `graphql-introspection` |
| `rt-webops` | OWASP Validation + App Analysis Heat Map | `sql-injection-*`, `idor`, `ssrf`, `xss`, `jwt-auth`, `mass-assignment`, `rate-limit-bypass`, `bfla`, `api-schema-validation` |
| `rt-access` | MITRE ATT&CK PrivEsc + Lateral Movement + Defense Evasion | `priv-escalation`, `lateral-movement` |
| `rt-debrief` | MITRE Mapping, Detection Gaps, Executive Reporting | `retrospective` |

## Suggested Topic Routing

| Topic | Agent | Primary Roles |
|-------|-------|----------------|
| `General` | `rt-lead` | Routing, MITRE Attack Lifecycle, Timebox, Budget |
| `01-Recon` | `rt-recon` | Subdomain Enum, Live Hosts, Tech Stack, Params |
| `02-WebOps` | `rt-webops` | OWASP Exploitation, App Analysis Heat Map, XSS Pipeline |
| `03-Access` | `rt-access` | PrivEsc, Lateral Movement, Defense Evasion, C-I-A Impact |
| `04-Debrief` | `rt-debrief` | Attack Narrative, MITRE Mapping, Detection Gaps, Scoring |

## Skills ทั้งหมด (17 skills)

| Skill | Agent หลัก | MITRE Tactic |
|-------|-----------|--------------|
| `web-discovery` | rt-recon | TA0043 Reconnaissance |
| `network-recon` | rt-recon | TA0043 Reconnaissance |
| `graphql-introspection` | rt-recon | TA0043 Reconnaissance |
| `sql-injection-union` | rt-webops | TA0001 Initial Access |
| `sql-injection-error` | rt-webops | TA0001 Initial Access |
| `sql-injection-blind` | rt-webops | TA0001 Initial Access |
| `xss` | rt-webops | T1059.007 Execution |
| `ssrf` | rt-webops | TA0001 Initial Access |
| `idor` | rt-webops | TA0006 Credential Access |
| `jwt-auth` | rt-webops | TA0006 Credential Access |
| `bfla` | rt-webops | TA0004 Privilege Escalation |
| `mass-assignment` | rt-webops | TA0001 Initial Access |
| `rate-limit-bypass` | rt-webops | TA0001 Initial Access |
| `api-schema-validation` | rt-webops | TA0001 Initial Access |
| `priv-escalation` | rt-access | TA0004 Privilege Escalation |
| `lateral-movement` | rt-access | TA0008 Lateral Movement |
| `retrospective` | rt-debrief | Reporting |


## Scenario -> Skills

| Scenario | Recon Skills | Exploit Skills (WebOps) | Debrief Skills |
|----------|--------------|-------------------------|----------------|
| `web-lab-sqli-basic` | `web-discovery`, `network-recon` | `sql-injection-union`, `sql-injection-error`, `sql-injection-blind` | `retrospective` |
| `web-lab-authz-bypass` | `web-discovery`, `network-recon` | `idor`, `jwt-auth` | `retrospective` |
| `web-lab-ssrf-pivot` | `web-discovery`, `network-recon` | `ssrf` | `retrospective` |
| `web-lab-client-attacks`| `web-discovery`, `network-recon` | `xss` | `retrospective` |
| `api-lab-mass-assign` | `web-discovery` | `mass-assignment`, `bfla` | `retrospective` |
| `api-lab-rate-limit` | `web-discovery` | `rate-limit-bypass` | `retrospective` |
| `api-lab-schema-abuse` | `web-discovery` | `api-schema-validation`, `mass-assignment` | `retrospective` |
| `api-lab-graphql` | `web-discovery`, `graphql-introspection` | `bfla`, `idor` | `retrospective` |

## Agent -> Skills

| Agent | Core Focus (Web/API & Kali) | Skills ที่ใช้หลัก |
|-------|----------------------------|-------------------|
| `rt-recon` | Information Gathering, Asset Identification | `web-discovery`, `network-recon`, `graphql-introspection` |
| `rt-webops` | OWASP Validation, Vulnerability Proving | `sql-injection-*`, `idor`, `ssrf`, `xss`, `jwt-auth`, `mass-assignment`, `rate-limit-bypass`, `bfla`, `api-schema-validation` |
| `rt-access` | ISO 27001 C-I-A Impact assessment | ตรวจสอบ Evidence จาก WebOps เพื่อตีราคาความเสี่ยง |
| `rt-debrief`| Reporting, Mitigation planning | `retrospective` |

## Suggested Topic Routing

| Topic | Agent | Primary Roles (ISO 27001 compliant) |
|-------|-------|------------------------------------|
| `General` | `rt-lead` | Routing, ควบคุมกรอบเวลา (Timebox) และ Budget |
| `01-Recon` | `rt-recon` | ค้นหา Asset และจำกัดขอบเขตไม่ให้หลุด Scope |
| `02-WebOps` | `rt-webops`| ทดสอบ Payload ผ่าน Kali Tools ตามแนวทาง OWASP |
| `03-Access` | `rt-access`| ประเมินผลเสียหากข้อมูลรั่ว (Risk/Impact Assessment) |
| `04-Debrief`| `rt-debrief`| รวบรวมข้อมูล จัดพิมพ์รายงานและ Mitigation Plan |
