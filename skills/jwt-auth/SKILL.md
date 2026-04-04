---
name: jwt-auth
description: การทดสอบค้นหาช่องโหว่การจัดการ Session และ Authentication บนระบบ Web/API ที่ใช้ JSON Web Tokens (JWT)
---

# SKILL: jwt-auth

## Purpose
ตรวจสอบและทดสอบระบบการยืนยันตัวตน (Authentication) ที่ใช้งาน **JWT (JSON Web Tokens)** ภายใน Web Applications และ REST API เพื่อหาการตั้งค่าที่ไม่ปลอดภัย อ้างอิงตาม **OWASP Top 10 (A07:2021-Identification and Authentication Failures)** ภายใต้เงื่อนไขความปลอดภัยและจำกัดความเสี่ยงตามหลัก **ISO 27001**.

## Focus Areas
- **Target:** API Endpoints ที่รับ Header `Authorization: Bearer <token>`, Session Cookies.
- **Frameworks:** OWASP Top 10 (A07:2021), ISO 27001 (Access Control, User Authentication).
- **Tooling:** ชุดเครื่องมือบน **Kali Linux** เช่น `jwt_tool`, `jwt-cracker`, Burp Suite (JSON Web Tokens Extension).

## Required Inputs
- `target_endpoint`: API Endpoint.
- `valid_jwt_token`: Token ที่ได้รับอนุญาตให้เข้าถึงระบบ.
- `timebox_minutes`: กำหนดเวลาสูงสุดในการประเมิน.

## Workflow

1. **Information Gathering**
   - ถอดรหัสโครงสร้างของ JWT Token สังเกตการบอกชนิดของอัลกอริทึมใน Header (`alg`) และเนื้อหาใน Payload (เช่น `role: "user"`).

2. **Validation (Proof of Concept - Kali Tools)**
   - ตรวจสอบ `None Algorithm Attack`: ปรับแก้ header ให้ `"alg": "none"` พร้อมตัด Signature ออก ตรวจสอบว่า API อนุญาตให้ผ่านหรือไม่.
   - ตรวจสอบ `Improper Signature Validation`: แก้ไข Payload (อาทิ `role: "admin"`) และส่ง Token โดยไม่ต้องทำ Signature ใหม่ หรือดัดแปลง Secret ผิดหลัก.
   - `Brute-force / Cracking`: ตรวจสอบความแข็งแกร่งของ Secret Key ที่ใช้สร้าง Signature.
   - **Kali Tools:**
     - `jwt_tool` (`python3 jwt_tool.py <token>`) เพื่อ tamper และ crack.
     - `Burp Suite` JWT Extension เครื่องมือปรับแต่ง.

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - ความผิดพลาดนี้นำไปสู่ Account Takeover หรือการเพิ่มสิทธิ์เสมือน (Privilege Escalation) ซึ่งระบบบกพร่องทั้งระบบ **Access Control** ของ ISO ทันที.

4. **Reporting**
   - ชี้จุดที่ระบบรับคำขอยืนยันตัวตนผิดพลาด พร้อมอ้างอิงให้แก้ไขกระบวนการ Verify Signature อย่างเข้มงวด และใช้ asymmetric keys (RS256) แทนที่สมมาตรหากเป็นไปได้.

## Output Contract
- **JWT Vulnerability Evidence:** Token ที่ถูกเปลี่ยนแปลงแล้วสามารถใช้ผ่าน API ป้องกันได้.
- **Kali CLI Equivalent:** ผลลัพธ์จากการใช้งาน jwt-cracker หรือ jwt_tool.
- **Risk Assessment:** ประเมินความรุนแรง OWASP A07:2021 และให้แผนแก้ไข.

## Safety Guardrails
- **Offline Cracking Only:** การถอดรหัส Secret ผ่าน Brute-force ให้ดำเนินแบบออฟไลน์บนโลคอลเพื่อไม่ให้รบกวน Server.
- **No Real Takeover:** ห้ามเจาะเข้าไปสุ่มเปลี่ยนรหัสผ่าน หรือเปลี่ยนแปลงข้อมูลบัญชีผู้ใช้จริงบน Production หากทำ Privilege Escalation ไปเป็น Admin ได้ ให้ทำเพียงแค่ PoC ว่ามีสิทธิ์.
