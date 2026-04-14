# ⚡ Operational Flow 

กระบวนการ (Lifecycle) ตั้งแต่การติดเครื่องระบบครั้งแรก จนถึงรอบการจบนึง Assessment Session

## 1. Environment & Config Instantiation
เพื่อที่จะซ่อนค่า Secrets ไว้ ระบบใช้ `[[scripts/instantiate-config.sh]]` เพื่อสกัดเอาพารามิเตอร์ทั้ง 10 ตัวออกจาก `[[config-snippets/rt-training.env]]` นำมาใส่ทับลงบนไฟล์ `openclaw.rt-training.example.json` และเขียนออกมาเป็นไฟล์จริง
- **Env 10 ค่าควบคุม:** Gateway Token, Bot Token, Group ID, User ID, Topic IDs (x5), และ Control UI Origin

## 2. Agent Bootstrap Process
การคิกออฟ (Kickoff) การทำงานของ Agent จำเป็นต้องใช้ Bash Script เข้ามาช่วย เพราะ OpenClaw agents ไม่เริ่มต้นโจมตีเอง
- **ตัวจุดชนวน (The Starter):** รันคำสั่งทริกเกอร์ `[[scripts/init-agents.sh]]` (เช่น `./scripts/init-agents.sh web-lab-sqli-basic http://target.local`)
- นี่เป็นการยัด System Prompt ตามด้วยเป้าหมายและขอบเขตเวลา (Timebox) ให้กับ Agent ทั้ง 5 ทีมพร้อมกันเพื่อปลุกให้พร้อมส่งข้อความเข้าห้อง Telegram เด้งหาคุณ

## 3. During the Session (Handoff Protocol)
ระหว่างที่ทำ Assessment
- **State Management:** ข้อมูลสถานะและ Payload Proof of Concept จะถูกเขียนทับฝังอยู่ใน `sessions/<session_id>/session_state.json` (อ้างอิง `[[docs/HANDOFF_PROTOCOL.md]]`)
- **Agent Handoffs:** Agent แต่ละตัวจะส่งไม้วิ่งผลัดกัน หาก `rt-recon` แสกนเจอช่องรหัสผ่าน ก็จะเขียนหลักฐานลงไฟล์ JSON ก่อนแจ้ง `rt-webops` ไปรับไม้ต่อ

## 4. Closure & Debrief
- รัน `[[scripts/close-session.sh]]` เพื่อสั่งยุติการโจมตี
- `rt-debrief` ประเมินส่วนที่ขาดหาย (Detection Gaps)
