---
name: sql-injection-error
description: การทดสอบเจาะระบบและประเมินผลกระทบประเภท Error-Based SQL Injection สำหรับ Web Application และ API
---

# SKILL: sql-injection-error

## Purpose
ตรวจสอบและยืนยันการมีอยู่ของช่องโหว่ Error-Based SQL Injection ผ่าน Web Application และ API โดยอิงจาก **OWASP Top 10 (A03:2021-Injection)** และกำกับความรุนแรงตามแนวนโยบายของ **ISO 27001**. 

## Focus Areas
- **Target:** Web Applications, RESTful APIs, Action Endpoints.
- **Frameworks:** OWASP Top 10 (A03:2021-Injection, A05:2021-Security Misconfiguration), ISO 27001.
- **Tooling:** ชุดเครื่องมือใน **Kali Linux** เช่น sqlmap, Burp Suite, ZAP.

## Required Inputs
- `target_endpoint`: URL ของ Web หรือ API (รวม Header และ Body).
- `suspected_parameter`: จุดรับข้อมูลที่มีสิทธิ์เสี่ยง injection.
- `timebox_minutes`: กรอบเวลา.

## Workflow

1. **Information Gathering**
   - ใส่ข้อมูลผิดรูปแบบ เช่น `'` หรือ `"` หรือ payload เชิงคณิตศาสตร์.
   - ดูว่าระบบตอบสนองด้วย Database error leak หริอไม่ (เช่น MySQL syntax error).

2. **Validation (Proof of Concept - Kali Tools)**
   - ใช้ `Burp Suite Repeater` ยิง payload `AND (SELECT 1 FROM (SELECT COUNT(*),CONCAT(version(),FLOOR(RAND(0)*2))x FROM information_schema.tables GROUP BY x)a)`.
   - หรือใช้งาน `sqlmap` เพื่อจับ error messages (`sqlmap -u "<url>" -p "<param>" --technique=E --banner`).

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - การรั่วไหลของ Syntax และ Database version เป็นการเปิดเผยข้อมูล (Information Disclosure) ที่เพิ่มความเสี่ยงให้ Confidentiality (ISO 27001).
   - ประเมินความผิดพลาดของการตั้งค่า production ที่ยังเปิด error disclosure (OWASP Security Misconfiguration).

4. **Reporting**
   - นำ request/response ที่พบ error message มาใช้อ้างอิง พร้อมให้แก้ปัญหาโดยปิดการแสดง verbose error และใช้ ORM.

## Output Contract
- **Error-Based SQLi validation evidence:** แคปเจอร์ข้อความ Error ที่ปรากฏใน response.
- **Kali Tool Detail:** ชุดคำสั่ง sqlmap/curl ที่ทำให้เกิด error.
- **Risk Assessment:** กำหนดความรุนแรงและผลกระทบ CIA triad ตามกรอบ OWASP.

## Safety Guardrails
- **No Data Mutation:** Payload ทุกชิ้นต้องเป็นแบบ Read-Only และหลีกเลี่ยง Destructive Commands (`DROP`, `DELETE`, `UPDATE`) โดยสิ้นเชิง.
- **Data Minimization:** ดึงข้อมูลมาแค่เพียงพอพิสูจน์ช่องโหว่ (เช่น DB Version หรือ DB Name) ห้ามดึงข้อมูล users หรือ records ออกมาถ้าไม่จำเป็นต่อ POC.
