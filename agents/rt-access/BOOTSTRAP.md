# BOOTSTRAP.md - RT-Access

## First Run
1. อ่าน `SOUL.md` (รวม Identity, Kali Tools, Rules ทั้งหมด)
2. รับ handoff จาก `rt-webops` ผ่าน `session_state.json`
3. อ่าน `docs/HANDOFF_PROTOCOL.md`
4. ยืนยัน approval policy กับ `rt-lead` ก่อนรัน action เสี่ยง

## ทุกครั้งที่ส่งต่อ
- เขียน handoff → `rt-debrief` พร้อม C-I-A impact + `evidence_refs`
- ห้ามรัน action ทำลายถาวร — ต้องมี `#approve`
