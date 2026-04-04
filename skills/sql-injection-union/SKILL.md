---
name: sql-injection-union
description: การทดสอบเจาะระบบประเภท Union-Based SQL Injection บน Web/API อย่างปลอดภัยแบบมืออาชีพ
---

# SKILL: sql-injection-union

## Purpose
ทดสอบและประเมินผลกระทบช่องโหว่ Union-Based SQL Injection บน Web Application และ APIs อ้างอิงตาม **OWASP Top 10 (A03:2021-Injection)** และกำกับการเข้าถึงข้อมูลตามมาตรฐานการควบคุมทรัพยากรข้อมูลของ **ISO 27001**

## Focus Areas
- **Target:** Web pages, API Responses, Graph queries ที่มีการ return ข้อมูลกลับที่หน้าจอ.
- **Frameworks:** OWASP Top 10 (A03:2021-Injection), ISO 27001 (Confidentiality).
- **Tooling:** ชุดเครื่องมือใน **Kali Linux** เช่น sqlmap, Burp Suite, ffuf.

## Required Inputs
- `target_endpoint`: เป้าหมายในการทดสอบ (สามารถเป็น REST หรือ GraphQL).
- `suspected_parameter`: พารามิเตอร์เป้าหมาย.
- `timebox_minutes`: เวลาสูงสุดในการประเมิน.

## Workflow

1. **Column & Data Type Enumeration**
   - รัน Order By clause (`ORDER BY 1, 2, ...`) จนกว่าจะ Error เพื่อหาจำนวนคอลัมน์.
   - รัน Payload `UNION SELECT NULL, NULL...` เพื่อหา type ของแต่ละคอลัมน์.

2. **Validation (Proof of Concept - Kali Tools)**
   - ใช้ `Burp Suite` ในการ manually crafting union payloads.
   - ใช้เครื่องมือ `sqlmap` สำหรับ union test (`sqlmap -u "<url>" -p param --technique=U`).

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - หากทำสำเร็จ ข้อมูลจากต่าง Table จะถูกผสานและตอบกลับใน Response ของ Application ทำให้ศูนย์เสียสิทธิ์ความลับโดยสิ้นเชิง (Total Loss of Confidentiality).
   - ชี้แจงว่าจะเกิดผลกระทบต่อองค์กรในแง่ดาต้า Breach ได้อย่างไร (Risk Matrix).

4. **Reporting**
   - สรุปว่าสามารถ Exfiltrate ข้อมูล table อื่นๆ ของ application มาได้หรือไม่ ผ่าน HTTP Response.

## Output Contract
- **Union SQLi Evidence:** Payload และ Response ที่มีข้อมูลถูก inject ออกมาได้.
- **Reproducible Script:** curl / sqlmap usage snippets.
- **Risk Estimate:** ประเมินความรุนแรงตาม OWASP.

## Safety Guardrails
- **Read-Only Restrictions:** ยึดหลักปลอดภัยสูงสุด ห้าม inject ข้อมูลขยะกลับเข้าไป หรือเปลี่ยนแก้ไข state ในตาราง.
- **No Excessive Exfiltration:** ให้ Proof of concept ว่าดึงข้อมูลได้จริงเพียงแค่ 1-2 Records หรือเวอร์ชันฐานข้อมูล ห้ามดึงข้อมูล PII จำนวนมาก.
