# 🏗 Architecture & Tech Stack

## ภาพรวมโครงสร้างพื้นฐาน
โปรเจกต์ `openclaw-secops-readteam` ถูกออกแบบขึ้นมาเพื่อทำ Red Team Simulation แบบอัตโนมัติ ภายใต้กรอบของมาตรฐาน ISO 27001 (โจมตีเฉพาะ Authorized Target)

ระบบใช้คอมโพเนนต์หลักดังนี้:
1. **OpenClaw Gateway (v2026.4.12)**: เป็นตัว Orchestrator กลางที่รับโหลด Configuration, เชื่อมต่อกับ LLM Model (อิง MiniMax เป็นหลัก) และโหลด Plugins (Telegram, Terminal) ให้ Agents
2. **Kali Linux Toolkit**: สภาพแวดล้อมบังคับที่ Agents จะใช้เครื่องมืออย่าง `nmap`, `sqlmap`, `subfinder`, `dalfox`, `impacket`
3. **Telegram Forum Topics**: ทำหน้าที่เป็น Control Interface (Command Center) ประจำศูนย์ปฏิบัติการ

## 🌐 Telegram Bindings Schema (Flat bindings)
ตามมาตรฐานใหม่ของข้อกำหนด OpenClaw v2026.4.12 การตั้งค่า Agent ควบรวมกับห้องแชทใน Telegram จะใช้ **Flat Bindings** ผ่านค่า `chatId` แทนแบบเก่าที่เคยซ้อนรูปอยู่ใต้ `group`

กลไกคือเมื่อข้อความเข้าสู่ Topic ของ Telegram มันจะพก `Message Thread ID` มาด้วย ซึ่ง API ทางฝั่ง OpenClaw จะจัดการ Route ข้อความนั้นวิ่งไปหา Agent ที่ผูก ID ไว้แบบ 1-ต่อ-1:
- `REPLACE_TOPIC_ID_LEAD` ➡️ `rt-lead`
- `REPLACE_TOPIC_ID_RECON` ➡️ `rt-recon`
- `REPLACE_TOPIC_ID_WEBOPS` ➡️ `rt-webops`
- `REPLACE_TOPIC_ID_ACCESS` ➡️ `rt-access`
- `REPLACE_TOPIC_ID_DEBRIEF` ➡️ `rt-debrief`

*ดูรูปแบบโครงสร้าง JSON ฉบับเต็มได้ที่:* `[[config-snippets/openclaw.rt-training.example.json]]`
