# Session State Schema

## Session State คืออะไร?

`session_state.json` คือ **ไฟล์กลาง** ที่ทุก agent ในทีมอ่านและเขียนร่วมกัน เปรียบเหมือน **กระดานข่าวที่ทุกคนเห็นพร้อมกัน** ทำให้รู้ว่า:

- ตอนนี้อยู่ phase ไหน
- ใครทำอะไรเสร็จแล้ว
- ใครส่งต่องานให้ใคร
- คะแนนเท่าไหร่

---

## ที่เก็บไฟล์

```
sessions/
  <session-id>/
    session_state.json    <-- ไฟล์หลักของ session นั้น
```

ตัวอย่าง: `sessions/2026-03-30-sqli-basic/session_state.json`

---

## โครงสร้างข้อมูล (อธิบายทีละส่วน)

### ข้อมูลพื้นฐาน

- `session_id` — รหัสของ session (เช่น `2026-03-30-sqli-basic`)
- `scenario` — ชื่อ scenario ที่ใช้ (เช่น `web-lab-sqli-basic`)
- `started_at` / `ended_at` — เวลาเริ่ม/จบ session
- `timebox_minutes` — เวลาจำกัดทั้งหมด (ปกติ 180 นาที)

### scope (ขอบเขตที่อนุญาต)

- `targets` — เป้าหมายที่ใช้ฝึกได้ (เช่น `["http://127.0.0.1:3000"]`)
- `allowed_actions` — สิ่งที่ทำได้ (เช่น `["scan", "test injection"]`)
- `forbidden_actions` — สิ่งที่ห้ามทำ (เช่น `["scan production systems"]`)

### current_phase (ตอนนี้อยู่ขั้นไหน)

ค่าที่เป็นไปได้: `kickoff`, `recon`, `webops`, `access`, `debrief`, `closed`

### phases (รายละเอียดแต่ละขั้น)

แต่ละ phase มี:
- `name` — ชื่อขั้นตอน
- `status` — สถานะ (`pending`, `active`, `completed`, `skipped`)
- `owner` — agent ที่รับผิดชอบ
- `started_at` / `ended_at` — เวลาเริ่ม/จบของขั้นนั้น

### handoffs (การส่งต่องาน)

ดูรายละเอียดที่ `docs/HANDOFF_PROTOCOL.md` — แต่ละรายการบันทึกว่า agent ไหนส่งงานให้ agent ไหน พร้อมหลักฐานและความมั่นใจ

### findings (สิ่งที่ค้นพบ)

แต่ละรายการมี:
- `id` — รหัส (เช่น `F-001`)
- `phase` — พบในขั้นไหน
- `description` — อธิบายสั้นๆ
- `confidence` — ความมั่นใจ (`high`, `medium`, `low`)
- `evidence_ref` — อ้างอิงหลักฐาน

### hints_used / penalties

- `hints_used` — จำนวนครั้งที่ขอคำใบ้
- `penalties` — คะแนนที่ถูกหัก (ขอคำใบ้ครั้งละ -5)

### score (คะแนน)

- `recon_quality` — คุณภาพการสำรวจ (20 คะแนน)
- `exploit_reproducibility` — PoC ที่รันซ้ำได้ (30 คะแนน)
- `impact_proof` — พิสูจน์ผลกระทบแบบปลอดภัย (20 คะแนน)
- `evidence_quality` — คุณภาพหลักฐาน (15 คะแนน)
- `defensive_recommendations` — ข้อเสนอแนะเชิงป้องกัน (10 คะแนน)
- `time_discipline` — ทันเวลาหรือไม่ (5 คะแนน)
- `total` — รวม (100 - penalties)

### metrics (ตัวชี้วัด)

- `phase_durations_minutes` — เวลาที่ใช้ในแต่ละ phase
- `handoff_count` — จำนวนครั้งที่ส่งต่องาน
- `findings_count` — จำนวนสิ่งที่ค้นพบ
- `time_remaining_minutes` — เวลาที่เหลือ

---

## ใครอ่าน/เขียนอะไร

- `rt-lead` — สร้าง session, อัปเดต current_phase, อนุมัติ handoff
- `rt-recon` — เขียน findings, ส่ง handoff ไป rt-webops
- `rt-webops` — เขียน findings/PoC, ส่ง handoff ไป rt-access
- `rt-access` — เขียน impact proof, ส่ง handoff ไป rt-debrief
- `rt-debrief` — อ่านทุกอย่าง, เขียน score + metrics สุดท้าย
