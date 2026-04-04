# Handoff Protocol - มาตรฐานการส่งต่องานระหว่าง Agent

## Handoff คืออะไร?

Handoff คือ **การส่งต่องาน** จาก agent หนึ่งไปยังอีก agent หนึ่ง

เปรียบเหมือนการส่งไม้ในการวิ่งผลัด:
1. ผู้ส่งต้องบอกว่า "พบอะไร" พร้อมหลักฐาน
2. ผู้รับต้องรู้ว่า "ต้องทำอะไรต่อ"
3. ทุกอย่างบันทึกไว้ใน session_state.json

---

## ทำไมต้องมี Handoff Protocol?

- ป้องกันข้อมูลหายระหว่างส่งต่อ
- ทำให้ตรวจย้อนกลับได้ว่าใครพบอะไร เมื่อไหร่
- วัดประสิทธิภาพของทีมได้จากจำนวนและคุณภาพ handoff

---

## เส้นทางส่งต่อมาตรฐาน

```
rt-lead (เริ่ม session)
    |
    v
rt-recon (สำรวจเป้าหมาย)
    |
    v
rt-webops (โจมตีจุดอ่อน Web/API)
    |
    v
rt-access (พิสูจน์ผลกระทบ)
    |
    v
rt-debrief (สรุปคะแนน + บทเรียน)
    |
    v
rt-lead (ปิด session)
```

---

## Handoff Record - โครงสร้างที่ต้องเขียน

ทุกครั้งที่ส่งต่องาน ให้เพิ่ม record นี้ลงใน `handoffs[]` ของ session_state.json:

```json
{
  "id": "H-001",
  "timestamp": "2026-03-30T10:45:00+07:00",
  "from_agent": "rt-recon",
  "to_agent": "rt-webops",
  "summary": "พบ SQL injection endpoint ที่ /api/products?id= (error-based)",
  "confidence": "high",
  "evidence_refs": ["F-001", "F-002"],
  "next_action": "ทดสอบ UNION-based extraction บน endpoint นี้",
  "status": "accepted"
}
```

### อธิบายแต่ละ field

| field | คืออะไร | ตัวอย่าง |
|-------|---------|----------|
| id | รหัส handoff เรียงลำดับ | `H-001`, `H-002` |
| timestamp | เวลาที่ส่งต่อ | `2026-03-30T10:45:00+07:00` |
| from_agent | agent ผู้ส่ง | `rt-recon` |
| to_agent | agent ผู้รับ | `rt-webops` |
| summary | สรุปสิ่งที่พบ (2-3 ประโยค) | `พบ SQL injection ที่ /api/...` |
| confidence | ความมั่นใจ | `high` / `medium` / `low` |
| evidence_refs | อ้างอิง finding | `["F-001"]` |
| next_action | แนะนำสิ่งที่ควรทำต่อ | `ทดสอบ UNION extraction` |
| status | สถานะ | `pending` / `accepted` / `rejected` |

---

## ระดับความมั่นใจ (Confidence)

- **high** — มั่นใจ 80%+ ว่าช่องโหว่จริง มี evidence ยืนยัน
- **medium** — มีสัญญาณ แต่ต้องทดสอบเพิ่ม
- **low** — เป็นข้อสงสัย ยังไม่มี evidence ชัดเจน

---

## ขั้นตอนการส่งต่อ (Step-by-Step)

### ผู้ส่ง (เช่น rt-recon)

1. สรุป findings ที่เกี่ยวข้อง
2. ระบุ confidence level
3. เขียน handoff record ลง session_state.json
4. แจ้งใน Telegram topic ของผู้รับ: "ส่ง handoff H-001 ให้ @rt-webops"

### ผู้รับ (เช่น rt-webops)

1. อ่าน handoff record จาก session_state.json
2. ตรวจ evidence ที่อ้างถึง
3. อัปเดต status เป็น `accepted` หรือ `rejected`
4. ถ้า rejected ให้ระบุเหตุผลและส่งกลับผู้ส่ง

### rt-lead (ผู้อนุมัติ)

- ตรวจสอบ handoff ก่อนเปลี่ยน phase
- อนุมัติด้วยการเปลี่ยน current_phase ใน session_state.json

---

## ตัวอย่างจริง: Scenario SQLi Basic

### Handoff 1: rt-recon -> rt-webops

```json
{
  "id": "H-001",
  "timestamp": "2026-03-30T10:30:00+07:00",
  "from_agent": "rt-recon",
  "to_agent": "rt-webops",
  "summary": "Juice Shop /rest/products/search?q= - พบ error message จาก SQLite เมื่อส่ง single quote, ไม่มี WAF",
  "confidence": "high",
  "evidence_refs": ["F-001"],
  "next_action": "ทดสอบ UNION SELECT เพื่อดึงข้อมูล Users table",
  "status": "pending"
}
```

### Handoff 2: rt-webops -> rt-access

```json
{
  "id": "H-002",
  "timestamp": "2026-03-30T11:15:00+07:00",
  "from_agent": "rt-webops",
  "to_agent": "rt-access",
  "summary": "SQLi ยืนยันแล้ว - ดึง Users table ได้ด้วย UNION SELECT, ได้ email + password hash ของ admin",
  "confidence": "high",
  "evidence_refs": ["F-001", "F-003"],
  "next_action": "ลอง login ด้วย admin credentials ที่ได้, ทดสอบ admin panel access",
  "status": "pending"
}
```

### Handoff 3: rt-access -> rt-debrief

```json
{
  "id": "H-003",
  "timestamp": "2026-03-30T11:45:00+07:00",
  "from_agent": "rt-access",
  "to_agent": "rt-debrief",
  "summary": "เข้า admin panel สำเร็จ - สามารถอ่าน/แก้ไข/ลบ products ได้, data leak ทั้ง users table",
  "confidence": "high",
  "evidence_refs": ["F-001", "F-003", "F-005"],
  "next_action": "สรุป attack chain, ให้คะแนน, แนะนำ defensive measures",
  "status": "pending"
}
```

---

## Handoff ที่ถูก Reject

ถ้าผู้รับเห็นว่า evidence ไม่พอ ให้:

1. เปลี่ยน status เป็น `rejected`
2. เพิ่ม field `rejection_reason`
3. ส่งกลับผู้ส่งเพื่อหาข้อมูลเพิ่ม

```json
{
  "id": "H-001",
  "status": "rejected",
  "rejection_reason": "ไม่พบ error message ตามที่แจ้ง อาจเป็น false positive"
}
```

---

## Prompt สำหรับ Telegram

ใช้ prompt เหล่านี้ใน Telegram topic เพื่อสั่งให้ agent ทำ handoff:

**สั่งส่งต่อ:**
> สรุป findings แล้วส่ง handoff ให้ rt-webops เขียนลง session_state.json

**สั่งรับงาน:**
> อ่าน handoff ล่าสุดจาก session_state.json แล้วเริ่มทำตาม next_action

**สั่งตรวจ:**
> ตรวจ handoffs ทั้งหมดใน session_state.json ว่าครบและ accepted หรือยัง
