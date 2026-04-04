# Skill: rate-limit-bypass

## Meta
- **ID:** `rate-limit-bypass`
- **Agent:** `rt-webops`
- **OWASP API:** API4:2023 — Unrestricted Resource Consumption
- **Kali Tools:** ffuf, wfuzz, Burp Intruder, curl
- **ISO 27001:** Availability impact assessment

## Objective
ทดสอบว่า API มี rate limiting ป้องกัน brute force, credential stuffing, หรือ resource exhaustion หรือไม่

## Steps
1. ระบุ endpoint ที่ควรมี rate limit (login, OTP, password reset, search)
2. ส่ง request ซ้ำ 50-100 ครั้งด้วย ffuf/wfuzz
3. ตรวจว่ามี HTTP 429 หรือ block mechanism หรือไม่
4. ทดสอบ bypass: เปลี่ยน header (X-Forwarded-For, X-Real-IP)
5. PoC: แสดงว่า brute force สำเร็จโดยไม่ถูก block

## Constraints
- จำกัด request ≤ 100 ครั้งต่อ test
- ห้าม DoS target (ลดความเร็วถ้า server ช้า)
- ใช้ test credentials เท่านั้น

## Evidence Required
- Request count + response time graph
- HTTP status codes ที่ได้
- Bypass technique ที่ใช้ (ถ้ามี)
- OWASP API4:2023 mapping
- CIA Impact: Availability MEDIUM, Confidentiality HIGH (ถ้า brute force สำเร็จ)
