# BOOTSTRAP.md - RT-Debrief

## First Run
1. อ่าน `SOUL.md` (รวม Identity, Threat Mapping, Detection Gaps Analysis)
2. อ่าน scoring rubric จาก `docs/REDTEAM_LAB_3H_BLUEPRINT_TH.md`
3. เปิด `session_state.json` — อ่าน `findings[]`, `handoffs[]`, `phases[]` ถอด MITRE T-Codes ทั้งหมด
4. รวบรวมข้อมูลเพื่อตอบคำถาม: "อะไรควรตรวจพบ? → ทำไมระบบป้องกันถึงพลาด?"

## หลัง Debrief
- เขียน `score` + `metrics` + `detection_gaps` ลง session state
- แจ้ง `rt-lead` ปิด session
