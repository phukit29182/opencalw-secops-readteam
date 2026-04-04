# Skill: bfla (Broken Function Level Authorization)

## Meta
- **ID:** `bfla`
- **Agent:** `rt-webops`
- **OWASP API:** API5:2023 — Broken Function Level Authorization
- **Kali Tools:** Burp Suite, curl, Postman (CLI)
- **ISO 27001:** Confidentiality + Integrity impact assessment

## Objective
ทดสอบว่า normal user สามารถเรียก admin-only API endpoints ได้หรือไม่ (Vertical privilege escalation)

## Steps
1. Login เป็น normal user → จับ auth token
2. ค้นหา admin endpoints (เช่น `/api/admin/*`, `/api/users/all`, `/api/config`)
3. เรียก admin endpoints ด้วย normal user token
4. เปลี่ยน HTTP method (GET→PUT→DELETE) ทดสอบ method-level authz
5. PoC: แสดงว่า normal user เข้าถึง admin function ได้

## Constraints
- ใช้ test accounts เท่านั้น (normal + admin)
- ห้าม DELETE/modify production data
- PoC read-only ถ้าเป็นไปได้

## Evidence Required
- Normal user token + admin endpoint request/response
- HTTP method ที่ bypass ได้
- OWASP API5:2023 mapping
- CIA Impact: Confidentiality HIGH, Integrity HIGH
