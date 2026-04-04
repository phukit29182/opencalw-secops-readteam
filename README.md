# OpenClaw SecOps — Web/API Security Assessment Kit

ชุดเครื่องมือสำหรับ **ประเมินความปลอดภัย Web Application และ API** บน OpenClaw (Local Only)
ออกแบบให้ AI Agents 5 ตัวทำงานร่วมกันตามมาตรฐาน **OWASP Top 10** และ **ISO 27001** ควบคุมผ่าน Telegram Forum Topics ใช้เครื่องมือจาก **Kali Linux**

---

## Project Goals

- ใช้ `rt-*` agents แยกบทบาทชัดเจน (lead / recon / webops / access / debrief)
- ใช้ Telegram Topics เป็น Command Center
- เจาะเฉพาะ Authorized Target ที่ได้รับอนุญาตเท่านั้น (ISO 27001 Compliance)
- ผลลัพธ์ทุกชิ้นต้องผูกกับ **OWASP Top 10** Category
- ใช้เครื่องมือจาก **Kali Linux** ในทุกขั้นตอน

---

## Architecture

```
                     rt-lead
              (ISO 27001 Scope Control)
                   /    |    \
                  v     v     v
            rt-recon  rt-webops  rt-access
          (Kali Recon) (OWASP PoC) (CIA Impact)
                  \     |     /
                   v    v    v
                   rt-debrief
              (Report + Mitigation)
```

| Agent | หน้าที่ | เครื่องมือหลัก |
|-------|---------|---------------|
| `rt-lead` | ควบคุม Scope, Phase, Approval | OpenClaw CLI |
| `rt-recon` | Asset Discovery, Attack Paths | nmap, gobuster, ffuf |
| `rt-webops` | OWASP PoC (SQLi, XSS, IDOR, SSRF, JWT) | sqlmap, Burp, jwt_tool |
| `rt-access` | C-I-A Impact Assessment | impacket, netexec |
| `rt-debrief` | OWASP Report + ISO 27001 Scoring | Evidence Analysis |

---

## Quick Start (Kali, 10 นาที)

1. **ติดตั้ง OpenClaw + Telegram ครั้งแรก:** [docs/INSTALL_OPENCLAW_KALI_TH.md](docs/INSTALL_OPENCLAW_KALI_TH.md)
2. **เปิดระบบหลังติดตั้งแล้ว:** [RUNBOOK_KALI.md](RUNBOOK_KALI.md)
3. **Bootstrap Main Agent:** [docs/AGENT_BOOTSTRAP_GUIDE.md](docs/AGENT_BOOTSTRAP_GUIDE.md)

```bash
# 1. เตรียมค่า config
cp config-snippets/rt-training.env.example config-snippets/rt-training.env
# (กรอก 9 ค่า: Gateway Token, Bot Token, Group ID, User ID, และ 5 Topic IDs)

# 2. Generate config
./scripts/instantiate-config.sh --force

# 3. Deploy + Restart
cp config-snippets/openclaw.rt-training.generated.json ~/.openclaw/openclaw.json
openclaw gateway restart
openclaw channels status --probe
```

---

## วิธีหาค่า Config ทั้ง 9 ตัว (Telegram Setup)

ระบบต้องการค่า 9 ตัวเพื่อกรอกลงในไฟล์ `rt-training.env` ดังนี้:

**1. Gateway Token (`REPLACE_OPENCLAW_GATEWAY_TOKEN`)**
- หยาจาก: ไม่ต้องหา **ตั้งขึ้นเองได้เลย** เป็นรหัสผ่าน (ตัวอักษรผสมตัวเลขยาวๆ) เพื่อเชื่อมต่อระบบภายใน ไม่ให้อนุญาตใครแอบเข้ามารัน Agent

**2. Bot Token (`REPLACE_TELEGRAM_BOT_TOKEN_MAIN`)**
- เปิด Telegram ค้นหาบอทชื่อ `@BotFather` (ต้องมีติ๊กถูกสีฟ้า)
- พิมพ์คำสั่ง `/newbot` ตั้งชื่อให้เรียบร้อย
- ก๊อปปี้รหัสยาวๆ ใต้ข้อความ `Use this token to access the HTTP API:` มาใส่ (เช่น `1234567890:AAH_XxYy...`)

**3. Group ID (`REPLACE_TRAINING_GROUP_ID`)**
- สร้าง Group ใหม่ใน Telegram และไปเปิดโหมด **Topics (Forum)** ในหน้า Setting ของกลุ่ม
- ดึงบอทชื่อ `@getidsbot` เข้ากลุ่ม ทันทีที่เข้ามันจะรายงาน ID ของกลุ่ม เช่น `-100987654321`
- ⚠️ **สำคัญ:** ก๊อปปี้เฉพาะ "ตัวเลข" ตัดเครื่องหมายลบและ 100 ออก (จากตัวอย่างให้ก๊อปแค่ `987654321`)

**4. Trainer User ID (`REPLACE_TRAINER_USER_ID`)**
- ค้นหาบอทชื่อ `@userinfobot` พิมพ์ `/start` คุยกับมัน 
- มองหาบรรทัด `Id: 1234567` ก๊อปปี้ตัวเลขนั้นมาใส่ เพื่อให้ Agents รับคำสั่งจากคุณคนเดียว

**5-9. Topic IDs (`REPLACE_TOPIC_ID_*`)**
- ในกลุ่ม Forum ให้กด + สร้าง Topic ย่อย 5 ห้องให้เรียบร้อย (General, Recon, WebOps, Access, Debrief)
- เข้าไปแชท **"ข้างในแต่ละ Topic"** แล้วพิมพ์ข้อความเรียกบอท `@getidsbot`
- เมื่อบอทตอบกลับ ให้ดูที่บรรทัด `Message Thread ID:` (เช่น ห้อง Recon ตอบเลข `4`)
- นำเลขที่ได้ไปกรอกให้ตรงตามแต่ละห้อง (ห้องแรกสุดมักจะเป็นเลข `1` เสมอ)

---

## Running Scenarios (Automated)

รันคำสั่งเดียวเพื่อสร้าง Session และปลุก Agents เริ่มงานทันที:

```bash
# ทดสอบ Web Security (เช่น SQLi)
./scripts/init-agents.sh web-lab-sqli-basic http://target-web.local

# ทดสอบ API Security (เช่น Mass Assignment)
./scripts/init-agents.sh api-lab-mass-assign http://target-api.local

# เมื่อเสร็จสิ้น ปิด Session เพื่อประมวลผลคะแนน
./scripts/close-session.sh <session-id>
```
ดูรายละเอียด: [docs/DEMO_MODE.md](docs/DEMO_MODE.md)

---

## Telegram Topics

| Topic | Agent | บทบาท |
|-------|-------|-------|
| `General` | `rt-lead` | ISO 27001 Scope Control |
| `01-Recon` | `rt-recon` | Kali Discovery |
| `02-WebOps` | `rt-webops` | OWASP Validation |
| `03-Access` | `rt-access` | C-I-A Impact |
| `04-Debrief` | `rt-debrief` | Report + Score |

ดูการตั้งค่า Telegram: [docs/REDTEAM_TRAINING_TELEGRAM_TH.md](docs/REDTEAM_TRAINING_TELEGRAM_TH.md)

---

## Skills (OWASP Top 10 Mapped)

| Skill | OWASP | Target |
|-------|-------|--------|
| `sql-injection-*` | A03:2021 | Web/API |
| `xss` | A03:2021 (Client) | Frontend |
| `idor` | A01:2021 | Web/API |
| `ssrf` | A10:2021 | Backend |
| `jwt-auth` | A07:2021 | Auth |
| `mass-assignment` | API3:2023 | API |
| `rate-limit-bypass`| API4:2023 | API |
| `bfla` | API5:2023 | API |
| `api-schema-valid` | API8:2023 | API |
| `graphql-intro` | API9:2023 | API |
| `web-discovery` | Recon | All |
| `network-recon` | Asset ID | Infrastructure |
| `retrospective` | Reporting | All |

- ดูตาราง Scenario ↔ Skills: [skills/INDEX.md](skills/INDEX.md)
- Prompt snippets: [skills/PROMPTS.md](skills/PROMPTS.md)

---

## Session State

ทุก session มี `session_state.json` เป็นกระดานกลาง:

```
sessions/<session-id>/session_state.json
```

- Schema: [sessions/SESSION_STATE_SCHEMA.md](sessions/SESSION_STATE_SCHEMA.md)
- Template: [sessions/session_state.template.json](sessions/session_state.template.json)
- Handoff Protocol: [docs/HANDOFF_PROTOCOL.md](docs/HANDOFF_PROTOCOL.md)

---

## Core Docs

| เอกสาร | เนื้อหา |
|--------|---------|
| [INSTALL_OPENCLAW_KALI_TH.md](docs/INSTALL_OPENCLAW_KALI_TH.md) | ติดตั้ง OpenClaw + Telegram บน Kali |
| [AGENT_BOOTSTRAP_GUIDE.md](docs/AGENT_BOOTSTRAP_GUIDE.md) | Bootstrap `rt-lead` |
| [RUNBOOK_KALI.md](RUNBOOK_KALI.md) | เปิดระบบ ~10 นาที |
| [DEMO_MODE.md](docs/DEMO_MODE.md) | รัน Demo + Metrics |
| [HANDOFF_PROTOCOL.md](docs/HANDOFF_PROTOCOL.md) | กฎส่งต่องาน |
| [REDTEAM_LAB_3H_BLUEPRINT_TH.md](docs/REDTEAM_LAB_3H_BLUEPRINT_TH.md) | Blueprint 3 ชม. + OWASP Scoring |

---

## Safety & Compliance

- ✅ ใช้เฉพาะ Authorized Target ที่ได้รับอนุญาต (ISO 27001)
- ✅ ห้ามโจมตีระบบ Production
- ✅ Action เสี่ยงสูงต้องใช้ `#approve`
- ✅ ทุก PoC ต้องผูก OWASP Top 10 Category
- ✅ บันทึกหลักฐานและปิด Debrief ทุก Session
