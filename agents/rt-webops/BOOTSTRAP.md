# BOOTSTRAP.md - RT-WebOps

## First Run
1. อ่าน `SOUL.md` (รวม Identity, Kali Tools, App Analysis Heat Map, Rules)
2. รับ recon handoff จาก `session_state.json` → `handoffs[]` (params.txt, live_hosts.txt)
3. อ่าน `docs/HANDOFF_PROTOCOL.md`
4. ตรวจ Kali tools: `which dalfox`, `which paramspider`, `sqlmap --version`, `which burpsuite`

## ทุกครั้งที่ส่งต่อ
- เขียน handoff → `rt-access` พร้อม OWASP category + MITRE T-Codes + `evidence_refs`
