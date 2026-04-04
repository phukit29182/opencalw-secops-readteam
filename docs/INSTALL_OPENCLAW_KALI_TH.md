# คู่มือติดตั้ง OpenClaw บน Kali Linux (สำหรับ Trainer / มนุษย์)

เอกสารนี้อธิบาย **ตั้งระบบครั้งแรกแบบละเอียด** ก่อนใช้ [RUNBOOK_KALI.md](../RUNBOOK_KALI.md) แบบ 10 นาที

อ่านระดับ ม.ปลายได้ — ทำทีละขั้น อย่าข้ามขั้นตรวจสอบ

---

## สิ่งที่จะได้เมื่อจบ

- ติดตั้ง OpenClaw CLI + Gateway บน Kali
- มี Bot Telegram + กลุ่ม Forum + Topics สำหรับแยก agent
- โฟลเดอร์โปรเจกต์ `openclaw-secops` พร้อม generate `openclaw.json`
- รันคำสั่ง `openclaw gateway status` แล้วเห็นว่า Gateway ทำงาน

---

## ส่วน 1 — เครื่องที่ควรมี

| รายการ | แนะนำ |
|--------|--------|
| OS | Kali Linux (อัปเดตล่าสุด) |
| RAM | 8 GB ขึ้นไป (ถ้ารัน Burp + browser + gateway พร้อมกัน) |
| พื้นที่ดิสก์ | ~10 GB ว่าง (Docker images + Node) |
| อินเทอร์เน็ต | ใช้ติดตั้งแพ็กเกจและดาวน์โหลด OpenClaw |
| บัญชี AI | API key จากผู้ให้บริการโมเดล (ตอน onboard OpenClaw จะถาม) |

อัปเดตระบบก่อนเริ่ม:

```bash
sudo apt update && sudo apt full-upgrade -y
```

---

## ส่วน 2 — ติดตั้ง OpenClaw (ทางการ)

OpenClaw ใช้ **Node.js** (แนะนำ Node 24 หรือ 22.14+)

### 2.1 ตรวจ Node

```bash
node --version
```

ถ้าไม่มีหรือเวอร์ชันต่ำเกินไป ติดตั้ง Node บน Kali ตาม [เอกสาร Node ของ OpenClaw](https://docs.openclaw.ai/install/node) หรือใช้ NodeSource / nvm

### 2.2 ติดตั้ง OpenClaw (สคริปต์ทางการ)

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

หลังติดตั้ง ตรวจว่าเรียกคำสั่งได้:

```bash
openclaw --version
```

ถ้าเจอ `command not found` ให้เพิ่ม PATH ของ npm global (ตัวอย่าง):

```bash
export PATH="$(npm prefix -g)/bin:$PATH"
# ใส่บรรทัดนี้ใน ~/.bashrc ถ้าต้องการถาวร
```

### 2.3 Onboard ครั้งแรก (Gateway + โมเดล)

```bash
openclaw onboard --install-daemon
```

ทำตาม wizard: เลือกผู้ให้บริการโมเดล ใส่ API key ตั้งค่า Gateway

### 2.4 ตรวจ Gateway

```bash
openclaw gateway status
openclaw doctor
```

ถ้าทำงานปกติ จะเห็นว่า Gateway กำลัง listen (พอร์ตอาจเป็น 18789 ตามค่าเริ่มต้นของ OpenClaw — **โปรเจกต์ training อาจกำหนดพอร์ตอื่นใน `openclaw.json`** เช่น `3310` ในไฟล์ตัวอย่างของ repo นี้)

ทดสอบ UI:

```bash
openclaw dashboard
```

---

## ส่วน 3 — Python 3 (สำหรับ scripts)

### Python 3

```bash
python3 --version
```

Kali มักมีอยู่แล้ว — ใช้รัน `scripts/instantiate-config.sh`

---

## ส่วน 4 — Telegram Bot + กลุ่ม Forum + Topics

### 4.1 สร้าง Bot

1. เปิด Telegram คุยกับ [@BotFather](https://t.me/BotFather)
2. ส่ง `/newbot` ตั้งชื่อและ username
3. เก็บ **Bot Token** ไว้ (ห้ามแชร์ต่อคนอื่น)

### 4.2 สร้างกลุ่มแบบ Forum

1. สร้างกลุ่มใหม่ → ตั้งเป็น **Group** → เปิด **Topics** (Forum)
2. เพิ่ม Bot เข้ากลุ่ม ให้สิทธิ์อ่านข้อความ
3. สร้าง Topics แนะนำ (ชื่ออาจตั้งเอง แต่ต้องจับคู่ `message_thread_id` กับ config):
   - `General` (มักเป็น thread id `1` — **ตรวจจริงจาก Telegram / log**)
   - `01-Recon`
   - `02-WebOps`
   - `03-Access`
   - `04-Debrief`

### 4.3 หา Group ID และ Thread ID

- **Group ID** มักขึ้นต้นด้วย `-100...` ใช้บอทอย่าง @userinfobot / @getidsbot หรือดูจาก log เมื่อมีข้อความเข้ากลุ่ม (แล้วนำไปใส่ใน env — ดูส่วน 5)
- **Thread ID** ของแต่ละ topic: ส่งข้อความใน topic แล้วดู raw update หรือใช้วิธีที่ OpenClaw/Telegram แนะนำ — ต้องให้ตรงกับ `topics` ใน `openclaw.rt-training.example.json` (ตัวอย่างใช้ `1`, `101`–`104` — **แก้ให้ตรงกับกลุ่มคุณ**)

### 4.4 Trainer User ID

- หา **Telegram user id** ของคุณ (ตัวเลข) เพื่อใส่ใน `allowFrom` — เฉพาะ user นี้สั่งในกลุ่มได้ตาม policy ตัวอย่าง

รายละเอียดการออกแบบกลุ่ม: [REDTEAM_TRAINING_TELEGRAM_TH.md](REDTEAM_TRAINING_TELEGRAM_TH.md)

---

## ส่วน 5 — โคลน / วางโปรเจกต์ `openclaw-secops`

```bash
cd ~
git clone <path-to-your-local-or-mirror>/openclaw-secops.git
cd openclaw-secops
```

(ถ้าโฟลเดอร์มีอยู่แล้ว แค่ `cd` เข้าไป)

---

## ส่วน 6 — เชื่อม config ของโปรเจกต์เข้า OpenClaw

### 6.1 สร้างไฟล์ env

```bash
cp config-snippets/rt-training.env.example config-snippets/rt-training.env
nano config-snippets/rt-training.env
```

กรอก 4 ค่า:

| ตัวแปร | คืออะไร |
|--------|---------|
| `REPLACE_OPENCLAW_GATEWAY_TOKEN` | token ยืนยัน client กับ Gateway (ตั้งเองให้ยาวและสุ่ม เก็บเป็นความลับ) |
| `REPLACE_TELEGRAM_BOT_TOKEN_MAIN` | Bot Token จาก BotFather |
| `REPLACE_TRAINING_GROUP_ID` | เฉพาะตัวเลขหลัง `-100` ของกลุ่ม (เช่น กลุ่ม `-1001234567890` ใส่ `1234567890`) — สคริปต์จะสร้าง key เป็น `-100` + ค่านี้ |
| `REPLACE_TRAINER_USER_ID` | Telegram user id ของ trainer |

**สำคัญ:** หลังรัน `instantiate-config.sh` ให้เปิด `openclaw.rt-training.generated.json` ตรวจว่า **ไม่มีคำว่า `REPLACE` ค้าง** — ถ้ายังค้าง แก้ `rt-training.env` แล้ว generate ใหม่ หรือแก้ JSON มือ

### 6.2 Generate JSON

```bash
chmod +x scripts/instantiate-config.sh scripts/init-session.sh scripts/close-session.sh
./scripts/instantiate-config.sh --force
```

### 6.3 วางเป็น config หลักของ OpenClaw

```bash
mkdir -p ~/.openclaw
cp config-snippets/openclaw.rt-training.generated.json ~/.openclaw/openclaw.json
```

หมายเหตุ: ถ้าคุณเคย onboard แล้วและอยาก **รวม** การตั้งค่า (เช่น provider) กับไฟล์ training — ต้อง merge ด้วยมือหรือเครื่องมือ JSON ให้ไม่ทับค่าที่จำเป็น

### 6.4 Restart Gateway

```bash
openclaw gateway restart
openclaw channels status --probe
openclaw agents list --bindings
```

---

## ส่วน 7 — Checklist ก่อนเริ่มสอน

- [ ] `openclaw gateway status` / `openclaw doctor` ผ่าน
- [ ] ส่งข้อความในแต่ละ topic แล้ว route ถูก agent (ดู [RUNBOOK_KALI.md](../RUNBOOK_KALI.md))
- [ ] Target environment พร้อมใช้งาน (เข้าถึงได้จาก Kali)
- [ ] อ่าน `docs/HANDOFF_PROTOCOL.md` และ `sessions/SESSION_STATE_SCHEMA.md` คร่าวๆ
- [ ] (ถ้าใช้ multi-agent demo) ลอง `docs/DEMO_MODE.md`

สำหรับ **Main Agent (`rt-lead`)** ให้อ่านเพิ่ม: [AGENT_BOOTSTRAP_GUIDE.md](AGENT_BOOTSTRAP_GUIDE.md)

---

## อ้างอิงทางการ

- Getting Started: https://docs.openclaw.ai/getting-started  
- Install / Node: https://docs.openclaw.ai/install  
- Telegram channel: https://docs.openclaw.ai/channels/telegram  

---

## ความปลอดภัย

- ห้าม commit `rt-training.env` หรือ `openclaw.json` ที่มี token จริงลง Git
- ใช้เฉพาะ Authorized Target ที่ได้รับอนุญาตเท่านั้น (ISO 27001)
