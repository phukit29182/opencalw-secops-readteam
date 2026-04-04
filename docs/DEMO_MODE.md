# Demo Mode - รัน Assessment แบบ Quick Demo พร้อม Metrics

## Demo Mode คืออะไร?

วิธีสาธิตระบบ Multi-Agent Web/API SecOps ให้เห็นว่า Agent ทำงานร่วมกันภายใต้มาตรฐาน **OWASP Top 10** และ **ISO 27001** อย่างไร

---

## สิ่งที่ต้องมี

1. OpenClaw Gateway พร้อม (`openclaw gateway restart`)
2. Telegram Topics ตั้งค่าตาม `RUNBOOK_KALI.md`
3. Authorized Target ทำงานอยู่ (เช่น Juice Shop `http://127.0.0.1:3000`)

---

## Quick Start (3 ขั้นตอน)

### ขั้นที่ 1: เริ่ม session
```bash
cd ~/openclaw-secops
./scripts/init-session.sh web-lab-sqli-basic
```

### ขั้นที่ 2: ส่ง prompt ตามลำดับ

**Topic: General (`rt-lead`)**
```text
เริ่ม assessment: web-lab-sqli-basic
target: http://127.0.0.1:3000
rules: ISO 27001 Strict Scope, safe payload only
สั่ง rt-recon เริ่มค้นหา Web/API endpoints
```

**Topic: 01-Recon (`rt-recon`)**
```text
skill: web-discovery
target: http://127.0.0.1:3000
ใช้ Kali Tools (whatweb, ffuf) ค้นหา endpoints
ส่ง Top 3 attack paths + OWASP risk mapping → handoff rt-webops
```

**Topic: 02-WebOps (`rt-webops`)**
```text
อ่าน handoff จาก session_state.json
skill: sql-injection-union
ใช้ sqlmap/Burp ทดสอบ (read-only, safe payload)
ส่ง PoC พร้อม OWASP A03:2021 mapping → handoff rt-access
```

**Topic: 03-Access (`rt-access`)**
```text
#approve
ประเมิน CIA Impact จาก SQLi finding (ISO 27001)
พิสูจน์ information disclosure แบบ safe
ส่ง risk rating → handoff rt-debrief
```

**Topic: 04-Debrief (`rt-debrief`)**
```text
skill: retrospective
อ่าน session_state.json ทั้งหมด
สรุป: Timeline + OWASP mapping + ISO 27001 risk score
ให้คะแนน + Top 3 Web/API mitigation actions
```

### ขั้นที่ 3: ปิด session
```bash
./scripts/close-session.sh <session-id>
```

---

## ตัวอย่าง Metrics Output

```
==================================================
  SESSION CLOSED
==================================================
  Scenario      : web-lab-sqli-basic
  Duration      : 95.2 minutes
  OWASP Mapped  : A03:2021

--- Score ---
  recon_quality                 : 18
  exploit_reproducibility       : 28
  impact_proof                  : 18
  evidence_quality              : 14
  defensive_recommendations     : 9
  time_discipline               : 5
  TOTAL                         : 92
==================================================
```

---

## Scenario อื่นที่ใช้ Demo ได้

| Scenario | OWASP Focus | เวลาแนะนำ |
|----------|-------------|-----------|
| `web-lab-sqli-basic` | A03:2021 | 15-30 นาที |
| `web-lab-authz-bypass` | A01:2021, A07:2021 | 30-60 นาที |
| `web-lab-ssrf-pivot` | A10:2021 | 60-90 นาที |
| `web-lab-client-attacks` | A03:2021 (Client) | 30-60 นาที |

> ดู prompt เฉพาะ scenario ที่ [`skills/PROMPTS.md`](../skills/PROMPTS.md)
