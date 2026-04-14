# Gemini / Antigravity Workspace Rules

- **Project:** OpenClaw SecOps Red Team
- **Knowledge Core:** `[[LLM-WIKI/000_Home.md]]`
- **SOP (Standard Operating Procedures):**
  1. หากผู้ใช้ออกคำสั่งที่มีความซับซ้อน ให้ตรวจสอบ Context ภาพรวมจากไฟล์ใน `LLM-WIKI/` กลับไปกลับมาก่อนทำแผน (Implementation Plan)
  2. เน้นการใช้ **ภาษาไทย** ในการเขียน Document และการสื่อสารกับ Agent/User
  3. โปรเจกต์นี้เป็น Red Team Framework (จำลองการเจาะระบบทางไซเบอร์ ภายใต้มาตรฐาน ISO 27001) ต้องเคร่งครัดเรื่อง Guardrails ห้ามแก้ไขโค้ดในทิศทางที่อนุญาตให้ Agent ละเมิดไฟล์ระบบ (หลีกเลี่ยงการให้ Agent ลบหรืออ่านไฟล์นอก Target Scope)
  4. การอ้างถึงไฟล์ ใช้รูปแบบ Obsidian `[[wikilinks]]` เสมอ
