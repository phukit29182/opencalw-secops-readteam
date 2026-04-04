# คู่มือ Bootstrap สำหรับ Main Agent (`rt-lead`)

เอกสารนี้เขียนให้ **agent `rt-lead`** อ่านแล้วรู้ว่าต้องทำอะไรก่อนเริ่มประเมิน Web/API

---

## คุณคือใคร

ข้อมูล Identity, Kali Tools, Rules ทั้งหมดอยู่ใน **`agents/rt-lead/SOUL.md`** (ไฟล์เดียวครบ)

---

## ลำดับการอ่านไฟล์ (ทุกครั้งที่เริ่มงาน)

```
agents/rt-lead/
├── SOUL.md               ← (1) อ่านก่อน — รวมทุกอย่างไว้แล้ว:
│                              • Identity (Agent ID, Role, Channel)
│                              • Kali Tools (คำสั่งที่ใช้)
│                              • Rules & ข้อห้าม
│                              • Handoff & Session State (reference)
├── MEMORY.md             ← (2) ความจำระยะยาว
├── memory/YYYY-MM-DD.md  ← (3) ถ้ามี
└── HEARTBEAT.md          ← (4) เช็กงานค้าง
```


เอกสารทีม (อ่านเพิ่มเติม):
- `docs/HANDOFF_PROTOCOL.md` — โครงสร้าง handoff
- `sessions/SESSION_STATE_SCHEMA.md` — schema ของ session state
- `docs/REDTEAM_LAB_3H_BLUEPRINT_TH.md` — timebox + OWASP scoring

---

## Bootstrap Checklist

1. ยืนยันว่าทำงานใน **Authorized Environment** เท่านั้น (ISO 27001)
2. รู้ **Scope ID**, **Target URL**, **Timebox** (180 นาที) จาก SecOps Lead
3. เปิด `session_state.json` — ตรวจ `scope.targets` + `forbidden_actions`
4. ตรวจ Kali: `openclaw gateway status`
5. ประกาศ Kickoff ใน Topic General → สั่ง `rt-recon` เริ่ม recon

---

## Bootstrap เพื่อนร่วมทีม

ส่งข้อความนี้ไปแต่ละ Topic:

```text
Bootstrap: อ่าน agents/rt-*/SOUL.md ตาม role ของคุณ
Session: <session-id>
Scope: <URL>
ทุก finding ต้องผูก OWASP Category
ทุก handoff เขียนลง session_state.json ตาม docs/HANDOFF_PROTOCOL.md
```

---

## เมื่อจบ Assessment

1. `rt-debrief` เขียน `score` + `metrics` ลง session state
2. แจ้ง SecOps Lead รัน `./scripts/close-session.sh <session-id>`
3. ตั้ง `current_phase: closed` + `ended_at`

> Prompt สำหรับแต่ละ phase: [`skills/PROMPTS.md`](../skills/PROMPTS.md)
