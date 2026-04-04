# Skills Index (Web/API & ISO 27001 Ready)

เอกสารนี้รวบรวมและจัดจำแนกชาร์ต `scenario -> skills` ให้ทาง Trainers และ `rt-lead` สามารถใช้งานเครื่องมือบน **Kali Linux** ภายใต้มาตรฐาน **OWASP Top 10** และ **ISO 27001**.

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
