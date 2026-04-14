# 🤖 Agent Ecosystem (5-Node System)

โปรเจกต์นี้แยกการทำงานของ AI ออกเป็น 5 Roles อย่างชัดเจนเพื่อแยกประสาทสัมผัส และเพิ่มความปลอดภัย โดยแต่ละตัวจะมีกรอบกติกาใน `SOUL.md` และกรอบการคุยกับ User ใน `USER.md` ของตัวเอง

## 👑 rt-lead (SecOps Orchestrator)
- **Role:** ศูนย์กลางคุมทีม (ตั้งอยู่ที่ห้อง General)
- **หน้าที่:** จัดการ ISO 27001 Scope ควบคุม Timeline รวมการสรุป ส่งมอบการอ้างอิงให้ Commander (มนุษย์) ยืนยันการ `#approve` กิจกรรมที่มีความเสี่ยงสูง
- **สมองหลัก:** `[[agents/rt-lead/SOUL.md]]`

## 🔍 rt-recon (Reconnaissance Expert)
- **Role:** หน่วยข่าวกรอง (ห้อง 01-Recon)
- **หน้าที่:** ใช้ [Jason Haddix Methodology](https://github.com/jhaddix/tbhm) ในการหา subdomains, ports, endpoints แบบเงียบเชียบ
- **สมองหลัก:** `[[agents/rt-recon/SOUL.md]]`

## ⚔️ rt-webops (Web Exploitation)
- **Role:** หน่วยเจาะระบบแอปพลิเคชัน (ห้อง 02-WebOps)
- **หน้าที่:** หาช่องโหว่ทาง Web/API ผูกหลักการโจมตีกับ OWASP Top 10 เช่น SQLi, XSS, IDOR
- **สมองหลัก:** `[[agents/rt-webops/SOUL.md]]`

## 🔑 rt-access (Initial Access & Pivoting)
- **Role:** หน่วยยกระดับสิทธิ์และฝังตัว (ห้อง 03-Access)
- **หน้าที่:** ทำ Privilege Escalation (TA0004), เคลื่อนย้ายโครงข่าย Lateral Movement (TA0008)  
- **🚨 ควบคุมพิเศษ:** บังคับ **ห้ามทำ** Pivot เด็ดขาดจนกว่า Commander จะพิมพ์อนุมัติผ่าน `#approve`  
- **สมองหลัก:** `[[agents/rt-access/SOUL.md]]`

## 📊 rt-debrief (Analysis & Reporting)
- **Role:** ฝ่ายประเมินช่องโหว่และสรุปผล (ห้อง 04-Debrief)
- **หน้าที่:** ตีความข้อมูลทั้งหมดตลอด Session, ทำ Score Breakdown, และหา "Detection Gaps" (เหตุผลที่ว่าทำไมระบบ Defense ของเป้าหมายถึงเกิดความหละหลวม)
- **สมองหลัก:** `[[agents/rt-debrief/SOUL.md]]`
