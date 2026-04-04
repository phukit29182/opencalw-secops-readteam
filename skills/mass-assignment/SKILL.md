# Skill: mass-assignment

## Meta
- **ID:** `mass-assignment`
- **Agent:** `rt-webops`
- **OWASP API:** API3:2023 — Broken Object Property Level Authorization
- **Kali Tools:** Burp Suite, curl, httpie
- **ISO 27001:** Integrity impact assessment

## Objective
ทดสอบว่า API ยอมรับ property ที่ไม่ควรให้แก้ไข (เช่น `role`, `isAdmin`, `balance`) ผ่าน POST/PUT/PATCH request

## Steps
1. สร้าง normal user account → จับ request body ตอน register/update
2. เพิ่ม property ที่ไม่มีใน form: `{"name":"test","role":"admin"}`
3. ส่ง request แล้วตรวจ response ว่า property ถูก save หรือไม่
4. PoC: แสดงว่า user ได้สิทธิ์สูงขึ้น

## Constraints
- ใช้ test account เท่านั้น
- ห้าม mass modify production data
- PoC ระดับพิสูจน์เท่านั้น (ไม่ escalate จริง)

## Evidence Required
- Request/Response diff (ก่อน vs หลัง)
- Property ที่ถูก overwrite
- OWASP API3:2023 mapping
- CIA Impact: Integrity HIGH
