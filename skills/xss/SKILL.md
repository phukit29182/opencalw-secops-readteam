---
name: xss
description: การทดสอบช่องโหว่ Cross-Site Scripting ด้วย Jason Haddix XSS Hunting Pipeline (ParamSpider → Gxss → dalfox) สอดคล้องกับ OWASP A03:2021 และ ISO 27001
---

# SKILL: xss

## Purpose
ตรวจสอบหาช่องโหว่ **Cross-Site Scripting (Reflected, Stored, DOM-based)** ด้วย Automated Hunting Pipeline ตาม **OWASP Top 10 (A03:2021-Injection)** — MITRE ATT&CK **T1059.007** (JavaScript Execution) การทดสอบใช้ Safe Payload เสมอ

## Focus Areas
- **Target:** Web Frontend, User Inputs, Query Parameters, API JSON Responses
- **Frameworks:** OWASP A03:2021 (Injection), ISO 27001 (Protection from Malicious Code), MITRE T1059.007
- **Tooling:** `ParamSpider`, `Gxss`, `dalfox`, `waybackurls`, `Burp Suite`, `nuclei` (-t xss/)

## Required Inputs
- `domain`: Target domain หลัก
- `params_file`: ไฟล์ params ที่ได้จาก `web-discovery` (`params.txt`)
- `timebox_minutes`: กำหนดเวลาสูงสุด

## Workflow

### Phase 1: Parameter Extraction
```bash
# จาก params.txt ที่ rt-recon ส่งมาแล้ว หรือขุดเพิ่มด้วย ParamSpider
python3 paramspider.py --domain $DOMAIN -o paramspider_out.txt

# รวมกับ waybackurls ที่มีอยู่
cat paramspider_out.txt params.txt | sort -u > all_params.txt
```

### Phase 2: Reflection Pre-filter (Gxss)
```bash
# กรอง params ที่ reflect input กลับมาในหน้า
cat all_params.txt | Gxss -p "test123" | tee reflected_params.txt
```

### Phase 3: Automated XSS Testing (dalfox)
```bash
# dalfox pipe mode — ทดสอบเฉพาะ reflected params
cat reflected_params.txt | dalfox pipe \
  --mining-dict all_params.txt \
  --silence \
  -o xss_results.txt

# ทดสอบ endpoint เดี่ยว
dalfox url "https://target.com/search?q=test" --silence
```

### Phase 4: Nuclei XSS Templates
```bash
nuclei -l live_hosts.txt -t vulnerabilities/xss/ -o nuclei_xss.txt
```

### Phase 5: Manual Validation (Burp Suite)
- ใช้ Burp Repeater ยืนยัน False Positive
- ทดสอบ WAF Bypass ด้วย encoding: `%3Cscript%3E`, `\u003cscript\u003e`
- ตรวจ DOM-based XSS ใน JavaScript source

## Output Contract
- `xss_results.txt` — Confirmed XSS endpoints จาก dalfox
- PoC Payload ที่ reproduce ได้ (Safe: `alert(document.domain)`)
- OWASP A03:2021 + MITRE T1059.007 mapping
- Recommendation: CSP Header, Input Sanitization, Output Encoding

## Safety Guardrails
- **Safe Payload Only:** ใช้เฉพาะ `alert()`, `console.log()` — ห้ามใช้ payload ที่ exfiltrate session token จริง
- **No Stored XSS on Shared Areas:** ห้าม inject บน production ที่ user อื่นใช้งานจริง — ต้องใช้ test account แยก
- **Rate Limit:** dalfox ใช้ `--delay` / `--timeout` เพื่อไม่ให้เกิด DoS


# SKILL: xss

## Purpose
ตรวจสอบหาช่องโหว่ **Cross-Site Scripting (Reflected, Stored, DOM-based)** ภายใน Web Applications และ Client-Side APIs ตามฐานข้อมูลความเสี่ยงของ **OWASP Top 10 (A03:2021-Injection)** ทั้งนี้เพื่อให้สอดคล้องกับมาตราฐาน **ISO 27001** การทดสอบจะเป็นการยืนยันแบบ Safe Payload เพื่อไม่ล่วงละเมิดข้อมูลผู้ใช้งานคนอื่น

## Focus Areas
- **Target:** Web Frontend, User Inputs, Query Parameters, API JSON Responses.
- **Frameworks:** OWASP Top 10 (A03:2021-Injection), ISO 27001 (Protection from Malware/Malicious code).
- **Tooling:** ชุดเครื่องมือบน **Kali Linux** เช่น XSStrike, Burp Suite, ZAP, XSSer.

## Required Inputs
- `target_endpoint`: URL ที่สงสัย.
- `suspected_parameter`: ฟอร์ม หรือตัวแปรทาง URL ที่รองรับ Input.
- `xss_type_focus`: ระบุประเภท (Reflected, Stored, DOM).
- `timebox_minutes`: กำหนดเวลาสูงสุดในการประเมิน.

## Workflow

1. **Information Gathering & Reconnaissance**
   - มองหา Input Vectors ทั้งกระบวนการส่ง Request POST/GET ไปยันการนำข้อมูลเหล่านี้มาแสดงผลในหน้าเว็บ (HTML source rendering).

2. **Validation (Proof of Concept - Kali Tools)**
   - ทดสอบสอดแทรก String payload ที่ปลอดภัย อาทิ `<script>console.log(document.domain)</script>` หรือ `"><img src=x onerror=prompt(1)>`.
   - **Kali Tools:**
     - ใช้งาน `Burp Suite Repeater` / `Intruder` ยิงลิส payload.
     - ใช้ `XSStrike` เพื่อวิเคราะห์ฟิลเตอร์ของ WAF และหาช่องทะลวง.

3. **Risk & Impact Assessment (ISO 27001 Compliance)**
   - หากหน้าเว็บ Execute script แสดงว่าอนุญาตให้ผู้โจมตีทำ Session Hijacking ขโมย API Token ของผู้ใช้คนอื่นได้ ส่งผลร้ายแรงด้าน **Confidentiality** (ตาม CIA triad).

4. **Reporting**
   - บันทึกและส่งต่อ Proof of Concept ขั้นตอนแสดงการ alert().
   - แนะนำการใช้ Content Security Policy (CSP) และ Input Sanitization แบบ Strict Context-Aware HTML Encoding.

## Output Contract
- **XSS validation evidence:** ภาพหน้าจอ หรือ DOM Output จากการรัน Payload.
- **Kali CLI Equivalent:** สคริปต์ที่ใช้หาช่องโหว่ หรือ Payload สั้นๆ.
- **OWASP/ISO 27001 Alignment:** เชื่อมโยงความเกี่ยวข้องของ Injection บน Client-Side.

## Safety Guardrails
- **Authorized & Harmless:** ห้ามรัน payload ที่ทำการขโมย session token เข้าเซิฟเวอร์ของผู้ทดสอบอย่างจริงจัง ให้ใช้เพียง Console log, Alert() เพื่อแสดง PoC.
- **No Propagation:** ห้ามใช้ Stored XSS ในพื้นที่สาธารณะของระบบ Production ซึ่งจะทำให้ User เข้าระบบแล้วโดยโจมตีจริง ให้สร้าง Account Test Isolation เพื่อตรวจสอบ.
