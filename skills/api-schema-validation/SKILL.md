# Skill: api-schema-validation

## Meta
- **ID:** `api-schema-validation`
- **Agent:** `rt-webops`
- **OWASP API:** API8:2023 — Security Misconfiguration
- **Kali Tools:** Burp Suite, curl, jq
- **ISO 27001:** Integrity impact assessment

## Objective
ทดสอบว่า API validate input schema อย่างเข้มงวดหรือไม่ (type confusion, extra fields, boundary values)

## Steps
1. จับ normal request → วิเคราะห์ expected schema
2. ส่ง type confusion: string แทน int, array แทน string
3. ส่ง extra/unexpected fields ที่ API ไม่ควรรับ
4. ส่ง boundary values: empty string, null, negative numbers, very long strings
5. ตรวจ error handling: stack trace leak, verbose errors
6. PoC: แสดงว่า API ยอมรับ input ที่ไม่ถูกต้อง

## Constraints
- ห้ามส่ง payload ที่ทำให้ DB corrupt
- จำกัดขนาด payload ≤ 1MB
- PoC ระดับพิสูจน์เท่านั้น

## Evidence Required
- Original vs malformed request + responses
- Error messages/stack traces ที่ leak
- Fields ที่ API ยอมรับโดยไม่ควร
- OWASP API8:2023 mapping
- CIA Impact: Integrity MEDIUM
