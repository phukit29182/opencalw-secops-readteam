---
name: network-recon
description: การแสกนและค้นหาเส้นทางเข้าสู่ Web Application และ API บน Infrastructure (Network Level)
---

# SKILL: network-recon

## Purpose
ตรวจสอบสถานะของ Host และค้นหาพอร์ตที่เปิดให้บริการแบบเน้นความปลอดภัย เพื่อนำมาสร้างโครงข่ายเป้าหมาย (Attack Surface) สำหรับการเจาะระบบ Web/API โดยยึดหลัก **ISO 27001** ด้านการระบุ Assets อย่างถูกต้องในขอบเขต (Scope).

## Focus Areas
- **Target:** Web Servers, Load Balancers, API Gateways, Reverse Proxies.
- **Frameworks:** ISO 27001 (Asset Identification).
- **Tooling:** เครื่องมือใน **Kali Linux** เช่น `nmap`, `masscan`, `rustscan`.

## Required Inputs
- `target_hosts_or_cidr`: รหัส IP/CIDR หรือ Hostname เป้าหมาย.
- `scan_policy`: ระบุระดับความรุนแรง (เช่น `safe` สำหรับตรวจสอบปกติ `aggressive` สำหรับเจาะลึกเฉพาะจุด).
- `timebox_minutes`: กรอบเวลาสำหรับการแสกนขอบเขตใหญ่.

## Workflow

1. **Host Discovery & Port Scanning (Kali Linux)**
   - ใช้เครื่องมือ `masscan` / `nmap` บน Kali เพื่อหาพอร์ตที่เปิดอยู่ (เป้าหมายหลัก: 80, 443, 8080, 8443 เป็นต้น).
   - ระบุกระบวนการค้นหา Service Version (`nmap -sV -sC -p <ports>`).

2. **Validation (Proof of Concept)**
   - ตรวจสอบว่าพอร์ตนั้นให้บริการ HTTP/HTTPS หรือไม่ (เพื่อปูทางสู่ `web-discovery`).

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - จัดทำรายการ Network Assets ที่เปิดเผยแก่สาธารณะ (Public Expsoures) และระบุความเสี่ยงตามมาตรฐาน ISO 27001 หากพบ Service ที่ไม่จำเป็น.

4. **Reporting**
   - ส่งออกผลลัพธ์เป็น Live hosts + Ports และ Service banner ให้ `rt-recon` และ `rt-lead`.

## Output Contract
- **Live Hosts & Open Ports:** ข้อมูล Asset ที่ตอบสนอง
- **Kali CLI Commands:** ตัวอย่างคำสั่ง nmap ที่ใช้งานครอบคลุม
- **Quick Risk Notes:** สรุปความจำเป็นของการเปิดพอร์ตเหล่านั้น

## Safety Guardrails
- **Safe Scanning:** ใช้ `scan_policy = safe` เสมอใน Production / สภาพแวดล้อมที่หวั่นไหวง่าย (เพื่อหลีกเลี่ยงผลกระทบต่อ Availability).
- **Scope Definition:** ห้ามแสกนทะลุ CIDR หรือ IP ภายนอกที่ไม่ได้รับใบอนุญาตประเมิน.
