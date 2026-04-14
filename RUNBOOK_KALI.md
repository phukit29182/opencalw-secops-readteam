# RUNBOOK_KALI.md

เอกสารนี้สรุปการ **เปิดระบบครั้งแรกให้พร้อมใช้งานภายใน ~10 นาที** (Local only) หลังติดตั้ง OpenClaw + Telegram เสร็จแล้ว

**ยังไม่เคยติดตั้ง OpenClaw?** ทำตามคู่มือละเอียดก่อน: [docs/INSTALL_OPENCLAW_KALI_TH.md](docs/INSTALL_OPENCLAW_KALI_TH.md)

---

## ลิงก์เอกสารที่เกี่ยวข้อง

| เอกสาร | ใช้ทำอะไร |
|--------|-----------|
| [skills/PROMPTS.md](skills/PROMPTS.md) | Prompt snippets + Guardrails |
| [docs/DEMO_MODE.md](docs/DEMO_MODE.md) | รัน demo + metrics แบบสั้น |
| [docs/HANDOFF_PROTOCOL.md](docs/HANDOFF_PROTOCOL.md) | กฎส่งต่องานระหว่าง agent |
| [sessions/SESSION_STATE_SCHEMA.md](sessions/SESSION_STATE_SCHEMA.md) | อธิบาย `session_state.json` |
| [docs/AGENT_BOOTSTRAP_GUIDE.md](docs/AGENT_BOOTSTRAP_GUIDE.md) | คู่มือให้ **rt-lead** bootstrap ระบบและทีม |

---

## 0) Prerequisites (1 นาที)

- Kali Linux + **OpenClaw ติดตั้งและ onboard แล้ว** ([INSTALL_OPENCLAW_KALI_TH.md](docs/INSTALL_OPENCLAW_KALI_TH.md))
- Python 3 (`python3 --version`) — ใช้กับสคริปต์ generate config / session
- Bot Telegram + กลุ่ม Forum + Topics ตั้งค่าแล้ว

---

## 1) เตรียมค่า config (2 นาที)

```bash
cd /path/to/openclaw-secops
cp config-snippets/rt-training.env.example config-snippets/rt-training.env
```

แก้ไฟล์ `config-snippets/rt-training.env` ให้ครบ 10 ค่า (ดูคำอธิบายใน `rt-training.env.example`):

- `REPLACE_OPENCLAW_GATEWAY_TOKEN`
- `REPLACE_TELEGRAM_BOT_TOKEN_MAIN`
- `REPLACE_TRAINING_GROUP_ID` (เฉพาะตัวเลขหลัง `-100`)
- `REPLACE_TRAINER_USER_ID`
- `REPLACE_TOPIC_ID_...` (ค่าประจำห้อง x 5 ห้อง)
- `REPLACE_CONTROL_UI_ORIGIN`

---

## 2) Generate openclaw config อัตโนมัติ (1 นาที)

```bash
chmod +x scripts/instantiate-config.sh scripts/init-session.sh scripts/close-session.sh
./scripts/instantiate-config.sh --force
```

จะได้ไฟล์:

- `config-snippets/openclaw.rt-training.generated.json`

เปิดไฟล์นี้ตรวจว่าไม่มี `REPLACE` ค้าง

---

## 3) ติดตั้ง config ไป OpenClaw (1 นาที)

```bash
mkdir -p ~/.openclaw
cp config-snippets/openclaw.rt-training.generated.json ~/.openclaw/openclaw.json
```

---

## 4) Restart และ health check (2 นาที)

```bash
openclaw gateway restart
openclaw channels status --probe
openclaw agents list --bindings
```

---

## 5) ทดสอบ Telegram Topics (2 นาที)

ส่งข้อความทดสอบในแต่ละ topic:

- General → ควรเข้า `rt-lead`
- 01-Recon → `rt-recon`
- 02-WebOps → `rt-webops`
- 03-Access → `rt-access`
- 04-Debrief → `rt-debrief`

ตรวจ log:

```bash
openclaw logs --follow
```

---

## 6) เริ่ม / ปิด Assessment Session + metrics (1–2 นาที)

**เริ่ม session** (สร้าง Session และ Bootstrap Agent ทันที):

```bash
./scripts/init-agents.sh web-lab-sqli-basic http://target-web.local
```

จด `session_id` ที่สคริปต์พิมพ์ออกมา (เช่น `2026-03-30-web-lab-sqli-basic`)

**ปิด session** และดูสรุป metrics:

```bash
./scripts/close-session.sh 2026-03-30-web-lab-sqli-basic
```

รายละเอียด prompt ต่อเนื่อง: [docs/DEMO_MODE.md](docs/DEMO_MODE.md)

---

## 7) Day-1 operation checklist (1 นาที)

- ตรวจว่าแต่ละ agent มี `memory/DAILY_LOG_TEMPLATE.md`
- เริ่มบันทึกวันด้วย `memory/YYYY-MM-DD.md` (คัดลอกจาก template)
- ยืนยันว่า action เสี่ยงสูงต้องมี `#approve` เสมอ
- ให้ **rt-lead** อ่าน [docs/AGENT_BOOTSTRAP_GUIDE.md](docs/AGENT_BOOTSTRAP_GUIDE.md) ก่อนเริ่ม lab จริง

---

## Troubleshooting แบบเร็ว

- **Bot ไม่ตอบใน group:** ตรวจว่า bot อยู่ใน group และเปิดสิทธิ์อ่านข้อความ
- **topic route ผิด:** ตรวจ `message_thread_id` ใน config ให้ตรงกับ topic จริง
- **gateway auth error:** ตรวจ token ใน `~/.openclaw/openclaw.json` ให้ถูกต้อง
- **`instantiate` แล้วยังมี REPLACE ใน JSON:** ตรวจว่ากรอก `rt-training.env` ครบ และรัน `./scripts/instantiate-config.sh --force` อีกครั้ง
