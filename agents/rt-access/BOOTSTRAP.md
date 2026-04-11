# BOOTSTRAP.md - RT-Access

## First Run
1. อ่าน `SOUL.md` (รวม Identity, MITRE TA0004 & TA0008, Tools, Rules)
2. รับ handoff จาก `rt-webops` ผ่าน `session_state.json`
3. อ่าน `docs/HANDOFF_PROTOCOL.md`
4. ตรวจ Kali tools: `netexec --version`, `impacket-psexec -h`, `which linpeas.sh`
5. ยืนยัน approval policy กับ `rt-lead` ก่อนรัน PrivEsc หรือ Lateral movement

## ทุกครั้งที่ส่งต่อ
- เขียน handoff → `rt-debrief` พร้อม Access Chain + C-I-A impact + MITRE T-Codes
- ห้ามรัน action เปลี่ยนแปลงระบบถาวร — ต้องมี `#approve`
