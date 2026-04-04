---
name: ssrf
description: การทดสอบเจาะระบบ Server-Side Request Forgery (SSRF) เพื่อประเมินผลกระทบการเข้าถึงแหล่งข้อมูลภายในตามมาตรฐานสากล
---

# SKILL: ssrf

## Purpose
ทดสอบและพิสูจน์ช่องโหว่ **Server-Side Request Forgery (SSRF)** ในระดับ Web และ API อ้างอิงจาก **OWASP Top 10 (A10:2021-SSRF)** และป้องกันผลกระทบกระทบให้สอดคล้องกับขอบเขตที่จำกัดตามมาตรฐานความปลอดภัยการจัดการเหตุการณ์ของ **ISO 27001**

## Focus Areas
- **Target:** Web Applications, APIs (ฟังก์ชัน URL-fetch, Webhooks, Image Parsers, File uploads).
- **Frameworks:** OWASP Top 10 (A10:2021-SSRF), ISO 27001 (Network Security Management).
- **Tooling:** เครื่องมือใน **Kali Linux** เช่น Burp Suite Collaborator, ZAP OAST, curl.

## Required Inputs
- `target_endpoint`: URL / API หรือ Parameter ที่เซิร์ฟเวอร์จะนำไป resolve (เช่น `?url=`).
- `allowed_internal_range`: IPs/Hostnames ที่อนุญาตให้ทดสอบดึงข้อมูลได้ (เช่น 127.0.0.1 หรือ internal lab CIDR).
- `timebox_minutes`: กำหนดเวลาสูงสุดในการทดสอบ.

## Workflow

1. **Information Gathering & Reconnaissance**
   - ตรวจจับฟังก์ชันที่มีการส่งออกข้อมูลขาออก (Outbound request) สู่ภายนอก.

2. **Validation (Proof of Concept)**
   - ทดสอบ External SSRF: บังคับให้ Server ส่งข้อมูลมาหาตัวรับที่ควบคุมได้ เช่น ใช้ `Burp Collaborator` เพื่อยืนยันว่าเกิด Out-of-band (OOB) network connect.
   - ทดสอบ Internal SSRF: เข้าถึง endpoint สู่ internal loopback (เช่น `http://localhost/admin`) หรือ Meta-data services แบบปลอดภัย.
   - **Kali Tools:**
     - `Burp Collaborator` หรือ Out-of-band listener บน Kali (เทียบเท่า `nc -lvnp`).
     - `ffuf` / `wfuzz` เพื่อ bypass blacklist (เช่น การแปล IP เปน Decimal/Octal).

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - ยืนยัน impact ของ Remote Code Execution, Cloud metadata extraction หากทำได้.
   - ดูผลกระทบด้าน Confidentiality (ขโมย source/config) และ Network traversal.

4. **Reporting**
   - รวบรวม matrix payload SSRF ที่ใช้เพื่อแสดงว่าหลุดฟิลเตอร์ใดบ้าง.

## Output Contract
- **SSRF Evidence:** HTTP callbacks, logs หรือ responses ที่แสดง internal content.
- **Payload & Tool Details:** ตัวอย่าง payload หรือ curl script.
- **OWASP/ISO 27001 Alignment:** Mapping ความเสี่ยงที่เจอกับ A10:2021-SSRF และแนะนำเรื่องการใช้นโยบาย Network Egress Filtering.

## Safety Guardrails (Operational Security)
- **Restricted Pivoting:** ห้ามใช้ SSRF แกะแสกน network ภายในระดับเจาะลึก (Heavy Port Scanning) เพราะอาจกระตุ้นระบบ IDS/IPS และห้ามออกนอก `allowed_internal_range`.
- **No Destructive Exploits:** ห้ามใช้ SSRF คู่กับ RCE exploits ภายในระบบ internal ถ้านอกเหนือ scope เด็ดขาด.
