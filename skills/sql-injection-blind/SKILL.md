---
name: sql-injection-blind
description: การทดสอบเจาะระบบและประเมินผลกระทบกรณี Blind SQL Injection (Boolean/Time-based) สำหรับ Web Application และ API ตามมาตรฐาน ISO 27001 และ OWASP Top 10
---

# SKILL: sql-injection-blind

## Purpose
ดำเนินการทดสอบเจาะระบบประเภท Blind SQL Injection (Boolean-based และ Time-based) บน Web Application และ API โดยอ้างอิงจากความเสี่ยง **OWASP Top 10 (A03:2021-Injection)** และปฏิบัติตามแนวทางการประเมินความเสี่ยงและควบคุมผลกระทบของ **ISO 27001** เพื่อให้กระบวนการทดสอบมีความปลอดภัย ตรวจสอบได้ และไม่กระทบต่อ Availability ของระบบ

## Focus Areas
- **Target:** Web Applications, RESTful APIs, GraphQL, SOAP.
- **Frameworks:** OWASP Top 10 (A03:2021-Injection), ISO 27001 (Information Security Incident Management & Access Control).
- **Tooling:** ชุดเครื่องมือที่มีใน **Kali Linux** (เช่น sqlmap, ffuf, wfuzz, Burp Suite).

## Required Inputs
- `target_endpoint`: URL ของ Web หรือ API ที่ต้องการทดสอบ (รวมถึง HTTP Method, Header, Body).
- `suspected_parameter`: พารามิเตอร์หรือตำแหน่งที่คาดว่ามีช่องโหว่ Injection (เช่น URL query params, JSON body, Header, Cookie).
- `timebox_minutes`: กำหนดเวลาสูงสุดในการทดสอบเพื่อจำกัดขอบเขตไม่ให้เกิดผลกระทบนานเกินไป.
- `max_requests`: จำนวน Request สูงสุดที่อนุญาตให้ยิง (ควบคุม Traffic เพื่อไม่ให้กระทบ Availability เชิง ISO 27001).
- `auth_token`: (Optional) JWT, Bearer token, หรือ Cookie สำหรับ endpoint ที่มีการพิสูจน์ตัวตน.

## Workflow

1. **Information Gathering & Reconnaissance (Kali Linux)**
   - สังเกตพฤติกรรมการตอบสนองของ Web/API ด้วยเครื่องมืออย่าง `Burp Suite` (บน Kali) หรือ `curl`.
   - วิเคราะห์ API documentation/Schema (ถ้ามี) เพื่อทำความเข้าใจโครงสร้างของ Request.

2. **Validation (Proof of Concept)**
   - ใช้ Payload แบบ Boolean-based (เช่น `AND 1=1`, `AND 1=2`) และสังเกตการเปลี่ยนแปลงใน Response (HTTP Status, Content-Length, ความแต่งต่างของโครงสร้าง JSON/HTML).
   - ใช้ Payload แบบ Time-based (เช่น `SLEEP(5)`, `pg_sleep(5)`, `WAITFOR DELAY '0:0:5'`) และจับเวลาการตอบสนองที่ล่าช้าผิดปกติ.
   - **Kali Tools:**
     - `Burp Suite` (Intruder) เพื่อยิง payload แบบมี structure
     - `ffuf` หรือ `wfuzz` เพื่อ inject payload และกรอง response ตามความยาวหรือสถานะ
     - `sqlmap` (สำคัญ: ต้องจำกัดความเร็วและตั้งค่าอย่างระมัดระวัง เช่น `--technique=B` หรือ `--technique=T` และห้ามใช้ thread สูงเพื่อไม่ให้ระบบล่ม `--threads=1`).

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - บันทึกพฤติกรรม Blind SQLi และหยุดการรันอัตโนมัติทันทีที่ได้ PoC ชัดเจน.
   - ประเมินในมุม C-I-A Triad (Confidentiality สูญเสียจากการเดาข้อมูล, Integrity หรือ Availability หากฐานข้อมูลถูก overload).
   - ปฏิบัติตามนโยบายความมั่นคงปลอดภัย ห้ามละเมิด Rule of Engagement หรือขโมยข้อมูลที่ไม่เกี่ยวข้อง (No Data Exfiltration).

4. **Reporting**
   - รวบรวมหลักฐานแสดง Request และ Response ที่สามารถนำไปใช้ทำซ้ำ (Reproduce) ได้จริง.
   - จับคู่ช่องโหว่ตามมาตรฐาน OWASP Top 10 (Injection)
   - ส่งผลประเมิน impact summary ยื่นแก่ `rt-access`

## Output Contract
- **Blind SQLi validation evidence:** พฤติกรรมที่บันทึกได้ Request/Response ที่ใช้ยืนยันช่องโหว่
- **Kali CLI Equivalent:** ตัวอย่างคำสั่งของระบบที่ถูกเรียกใช้เพื่อยืนยัน (ตัวอย่างเช่น sqlmap params ที่ใช้).
- **Request metrics:** สถิติจำนวน Request และจังหวะ Timing behavior ที่เกิดขึ้นระหว่างการทดสอบ.
- **OWASP/ISO27001 Alignment:** Impact summary ในมุมมอง C-I-A triad และ OWASP Top 10 Risk estimate.

## Safety Guardrails (Operational Security)
- **Controlled Request Rate:** ควบคุม delay ของ time-based payloads ไม่ควรตั้งค่าให้เกิดการหน่วงที่นานจนเกินเกณฑ์ของ loadbalancer หรือแอพ (เช่นจำกัดไว้ที่ 5-10 วินาที) ป้องกัน Database DoS.
- **Scope Limit:** ห้าม brute-force เกิน `max_requests` ที่กำหนดเด็ดขาด.
- **Data Minimization:** ทดสอบให้ถึงแค่ระดับ Proof of Concept (เช่น การดึงเวอร์ชัน db ล่าสุด, ปัจจุบัน) การสั่งดึงหรือ dump ข้อมูลขนาดใหญ่เป็นสิ่งที่ **ห้ามทำ** เด็ดขาด.
