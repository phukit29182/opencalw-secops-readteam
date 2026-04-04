---
name: web-discovery
description: การทำ Web & API Reconnaissance และ Information Gathering ให้สอดคล้องกับการวางแผนประเมินความเสี่ยงและ Rule of Engagement (ISO 27001)
---

# SKILL: web-discovery

## Purpose
สำรวจ Web Applications และ APIs อย่างครอบคลุมเพื่อค้นหา Endpoints, Parameters, และโครงสร้างที่ไม่ได้ซ่อนเร้นอย่างเป็นทางการ เป็นจุดเริ่มต้นของการประเมินช่องโหว่ โดยทำงานในระนาบของการจำกัดขอบเขต Scope อย่างเคร่งครัดตาม **ISO 27001**

## Focus Areas
- **Target:** Web Services, API endpoints (RESTful, GraphQL endpoints), JavaScript files source map.
- **Frameworks:** ISO 27001 (Rules of Engagement & Asset Mapping), OWASP Top 10 Security Misconfigurations.
- **Tooling:** ชุดเครื่องมือ Recon ใน **Kali Linux** เช่น `gobuster`, `feroxbuster`, `ffuf`, `nikto`, `whatweb`.

## Required Inputs
- `base_url`: Target หลักที่ต้องการประเมิน.
- `scope_rules`: โดเมน หรือ pattern ไหนที่อนุญาตให้แสกนได้ (Blacklist/Whitelist).
- `timebox_minutes`: เพดานเวลาการแสกน.

## Workflow

1. **Passive Recon & Technology Stack Identification (Kali Linux)**
   - วิเคราะห์ Tech Stack ของระบบด้วยคำสั่งอย่าง `whatweb <url>`.
   - วิเคราะห์ API Blueprint/Swagger หรือ robots.txt.

2. **Active Discovery (Proof of Concept)**
   - Brute-force directories และ API versions bằng `feroxbuster` หรือ `ffuf`.
   - ค้นหาพารามิเตอร์ที่ซ่อนอยู่ใน API endpoint เช่น `arjun` บน Kali.

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - จดบันทึก Endpoints สุ่มเสี่ยง เช่น Admin panels, Backup files, Debug APIs ซึ่งสามารถจับคู่ความเสี่ยงได้กับ Security Misconfiguration ของ OWASP.

4. **Reporting**
   - รวบรวมรายการที่ค้นพบจัดทำเป็น Endpoint inventory และจัดอันดับ Attack pathways ที่มีความเสี่ยงมากสุดเพื่อส่งต่อ `rt-webops`.

## Output Contract
- **Endpoint/Parameter Inventory:** ข้อมูลแผนผัง Asset ของ Web/API เป้าหมาย
- **Kali CLI Commands:** Command กรองผลลัพธ์ที่ใช้งานจริง
- **Top 3 Attack Paths:** สรุปโครงสร้างเส้นทางโจมตีที่มีโอกาสสำเร็จสูงสุด.

## Safety Guardrails (Operational Security)
- **Non-Destructive Scanning:** เครื่องมือค้นหา (Fuzzers/Brute-forcers) ต้องมีการตั้งค่า delay/rate limit ที่เหมาะสม (เช่น `--threads` ไม่เกินลิมิต) เพื่อป้องกันการทำ DoS เป้าหมาย (Availability Impact - ISO 27001).
- **In-Scope Boundary:** จำกัดการ discovery ห้ามออกสู่โดเมนภายนอกระบบ หรือ subdomains นอก scope เด็ดขาด.
