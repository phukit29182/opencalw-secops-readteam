---
name: xss
description: การทดสอบช่องโหว่ Cross-Site Scripting (XSS) ในฝั่ง Client-Side Application สำหรับ Web API / Frontend
---

# SKILL: xss

## Purpose
ตรวจสอบหาช่องโหว่ **Cross-Site Scripting (Reflected, Stored, DOM-based)** ภายใน Web Applications และ Client-Side APIs ตามฐานข้อมูลความเสี่ยงของ **OWASP Top 10 (A03:2021-Injection)** ทั้งนี้เพื่อให้สอดคล้องกับมาตราฐาน **ISO 27001** การทดสอบจะเป็นการยืนยันแบบ Safe Payload เพื่อไม่ล่วงละเมิดข้อมูลผู้ใช้งานคนอื่น

## Focus Areas
- **Target:** Web Frontend, User Inputs, Query Parameters, API JSON Responses.
- **Frameworks:** OWASP Top 10 (A03:2021-Injection), ISO 27001 (Protection from Malware/Malicious code).
- **Tooling:** ชุดเครื่องมือบน **Kali Linux** เช่น XSStrike, Burp Suite, ZAP, XSSer.

## Required Inputs
- `target_endpoint`: URL ที่สงสัย.
- `suspected_parameter`: ฟอร์ม หรือตัวแปรทาง URL ที่รองรับ Input.
- `xss_type_focus`: ระบุประเภท (Reflected, Stored, DOM).
- `timebox_minutes`: กำหนดเวลาสูงสุดในการประเมิน.

## Workflow

1. **Information Gathering & Reconnaissance**
   - มองหา Input Vectors ทั้งกระบวนการส่ง Request POST/GET ไปยันการนำข้อมูลเหล่านี้มาแสดงผลในหน้าเว็บ (HTML source rendering).

2. **Validation (Proof of Concept - Kali Tools)**
   - ทดสอบสอดแทรก String payload ที่ปลอดภัย อาทิ `<script>console.log(document.domain)</script>` หรือ `"><img src=x onerror=prompt(1)>`.
   - **Kali Tools:**
     - ใช้งาน `Burp Suite Repeater` / `Intruder` ยิงลิส payload.
     - ใช้ `XSStrike` เพื่อวิเคราะห์ฟิลเตอร์ของ WAF และหาช่องทะลวง.

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - หากหน้าเว็บ Execute script แสดงว่าอนุญาตให้ผู้โจมตีทำ Session Hijacking ขโมย API Token ของผู้ใช้คนอื่นได้ ส่งผลร้ายแรงด้าน **Confidentiality** (ตาม CIA triad).

4. **Reporting**
   - บันทึกและส่งต่อ Proof of Concept ขั้นตอนแสดงการ alert().
   - แนะนำการใช้ Content Security Policy (CSP) และ Input Sanitization แบบ Strict Context-Aware HTML Encoding.

## Output Contract
- **XSS validation evidence:** ภาพหน้าจอ หรือ DOM Output จากการรัน Payload.
- **Kali CLI Equivalent:** สคริปต์ที่ใช้หาช่องโหว่ หรือ Payload สั้นๆ.
- **OWASP/ISO 27001 Alignment:** เชื่อมโยงความเกี่ยวข้องของ Injection บน Client-Side.

## Safety Guardrails
- **Authorized & Harmless:** ห้ามรัน payload ที่ทำการขโมย session token เข้าเซิฟเวอร์ของผู้ทดสอบอย่างจริงจัง ให้ใช้เพียง Console log, Alert() เพื่อแสดง PoC.
- **No Propagation:** ห้ามใช้ Stored XSS ในพื้นที่สาธารณะของระบบ Production ซึ่งจะทำให้ User เข้าระบบแล้วโดยโจมตีจริง ให้สร้าง Account Test Isolation เพื่อตรวจสอบ.
