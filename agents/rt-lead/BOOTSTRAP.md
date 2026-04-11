# BOOTSTRAP.md - RT-Lead

## First Run
1. อ่าน `SOUL.md` (รวม Identity, Tools, MITRE Attack Lifecycle, Rules ทั้งหมดแล้ว)
2. อ่าน `docs/HANDOFF_PROTOCOL.md` + `sessions/SESSION_STATE_SCHEMA.md`
3. เปิด `session_state.json` — ตรวจ scope, phases, handoffs
4. ยืนยัน Kali env: `openclaw gateway status`, `python3 --version`
5. ส่ง bootstrap message ไปแต่ละ Topic ตาม `docs/AGENT_BOOTSTRAP_GUIDE.md`

## Every Session
- ควบคุมทีมให้อยู่ในกรอบ **MITRE Attack Lifecycle**
- ตรวจ `session_state.json` → อัปเดต `current_phase` → ตรวจ `handoffs[]` ข้อมูลครบถ้วนก่อนปิด phase
