# Skills Directory

โฟลเดอร์นี้เก็บ OpenClaw skills สำหรับ Web/API Security Assessment

โครงสร้างมาตรฐาน: `skills/<skill-id>/SKILL.md`

## Web Skills (OWASP Top 10)

- `web-discovery` — Jason Haddix Recon Pipeline (Subdomain/Params)
- `network-recon` — Port Scan & Service ID
- `sql-injection-union` — SQLi Union-based (A03:2021)
- `sql-injection-error` — SQLi Error-based (A03:2021)
- `sql-injection-blind` — SQLi Blind/Time-based (A03:2021)
- `idor` — Insecure Direct Object Reference (A01:2021)
- `ssrf` — Server-Side Request Forgery (A10:2021)
- `xss` — Cross-Site Scripting Pipeline (ParamSpider → Gxss → dalfox)
- `jwt-auth` — JWT Authentication Bypass (A07:2021)

## API Skills (OWASP API Security Top 10)

- `mass-assignment` — Broken Object Property Level Auth (API3:2023)
- `rate-limit-bypass` — Unrestricted Resource Consumption (API4:2023)
- `bfla` — Broken Function Level Authorization (API5:2023)
- `api-schema-validation` — Security Misconfiguration (API8:2023)
- `graphql-introspection` — Improper Inventory Management (API9:2023)

## Access Skills (MITRE ATT&CK)

- `priv-escalation` — SUID, Sudo, Unquoted Paths, Kerberoasting (TA0004)
- `lateral-movement` — Pass-the-Hash/Ticket, SMB Shares, impacket (TA0008)

## Reporting

- `retrospective` — MITRE Mapping, Detection Gaps & Assessment Report

## Quick References

- [`INDEX.md`](INDEX.md) — Scenario ↔ Skills mapping
- [`PROMPTS.md`](PROMPTS.md) — Prompt snippets + Guardrails (G1-G5)
