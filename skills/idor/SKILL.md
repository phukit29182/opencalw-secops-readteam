---
name: idor
description: การทดสอบเจาะระบบประเภท Insecure Direct Object References (IDOR) หรือ Broken Access Control บน Web Application และ API
---

# SKILL: idor

## Purpose
ดำเนินการทดสอบช่องโหว่ **IDOR / Broken Access Control** บน Web Application และ API โดยอ้างอิงความเสี่ยงจาก **OWASP Top 10 (A01:2021-Broken Access Control)** และปฏิบัติตามมาตรฐานการระบุผลกระทบด้านความลับของข้อมูลตาม **ISO 27001 (Confidentiality)** เพื่อยืนยันว่าผู้ใช้ไม่สามารถเข้าถึงข้อมูลของผู้ใช้อื่นได้

## Focus Areas
- **Target:** Web Applications, RESTful APIs, GraphQL endpoints, SOAP.
- **Frameworks:** OWASP Top 10 (A01:2021), ISO 27001 (Information Classification / Access Control).
- **Tooling:** เครื่องมือใน **Kali Linux** เช่น Burp Suite (Repeater, Intruder), curl.

## Required Inputs
- `target_flow`: URL หรือ API flow ที่ต้องการตรวจสอบ (เช่น `/api/v1/user/{id}/profile`).
- `authorized_identity`: Session token, JWT, หรือ Cookie ฝั่งผู้รับอนุญาต (User A).
- `unauthorized_identity`: Session token, JWT, หรือ Cookie ของผู้ที่ไม่มีสิทธิ์หรือสิทธิ์ต่ำกว่า (User B).
- `timebox_minutes`: เวลาสูงสุดในการประเมิน.

## Workflow

1. **Information Gathering (Kali Linux)**
   - สังเกต structure ของ resource identifiers ใน API/Web ด้วย `Burp Suite` (เช่น UUID, Integer ID).

2. **Validation (Proof of Concept)**
   - ขอบเขตที่ 1 (Baseline): ยิง request ด้วย identifier ของตนเอง และ `authorized_identity`
   - ขอบเขตที่ 2 (Bypass): นำ identifier ของ User A ไปใส่ใน request ที่ใช้ session ของ User B (`unauthorized_identity`)
   - **Kali Tools:** ใช้ `Burp Suite Repeater` แก้ไข Request หรือ `Autorize` plugin เพื่อตรวจสอบความแตกต่างของ Response อัตโนมัติ.

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - ยืนยันผลกระทบเชิงธุรกิจ: การละเมิดข้อมูลนี้สามารถเข้าถึง PII (Personally Identifiable Information) ได้หรือไม่ (พิจารณาผลกระทบด้าน Confidentiality).
   - ประเมินช่องทางการเกิด Data Manipulation: IDOR นี้เปลี่ยน state ของข้อมูล (POST/PUT/DELETE) ได้หรือไม่ (พิจารณาด้าน Integrity).

4. **Reporting**
   - เปรียบเทียบ Diff ของ Authorized vs Unauthorized Request/Response อย่างชัดเจน.

## Output Contract
- **Vulnerability Evidence:** ตัวอย่าง Request/Response ที่ยืนยันการทำ IDOR.
- **Kali CLI/Tool Example:** สรุปว่าใช้ Burp suite intercept จุดไหน พร้อม curl script ที่ทำซ้ำได้
- **OWASP/ISO 27001 Alignment:** เชื่อมโยงผลเข้าสู่ A01:2021-Broken Access Control.

## Safety Guardrails (Operational Security)
- **Authorized Test Data Only:** ห้ามทดสอบ IDOR เพื่อเข้าถึงข้อมูลระดับ Production ของลูกค้ารายอื่นโดยเด็ดขาด ให้ใช้ Account สำหรับทดสอบ (Test users) ในสภาพแวดล้อมที่ได้รับอนุญาตเท่านั้น.
- **No Data Destructions:** ห้ามใช้ IDOR คู่กับ DELETE API ในลักษณะกวาดล้างทรัพยากรระบบ เพราะจะกระทบ Availability.
