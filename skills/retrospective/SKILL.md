---
name: retrospective
description: จัดทำรายงานการประเมินเจาะระบบระดับ Executive ครอบคลุม Attack Narrative, MITRE ATT&CK Mapping, Detection Gaps และ ISO 27001 Risk Assessment
---

# SKILL: retrospective

## Purpose
แปลงหลักฐานทั้งหมดจากทีมเป็น **Executive Report** ที่มีคุณภาพมืออาชีพ โดยเชื่อมโยง **OWASP Top 10**, **MITRE ATT&CK Framework** และ **ISO 27001** พร้อมวิเคราะห์ **Detection Gaps** — จุดที่ระบบป้องกันควรตรวจพบแต่พลาด

## Focus Areas
- **Target:** Consolidated Evidence จาก rt-recon, rt-webops, rt-access
- **Frameworks:** ISO 27001 (Incident Management), OWASP Risk Rating, MITRE ATT&CK (สำหรับ Detection Gap Analysis)

## Required Inputs
- `session_state.json` → `findings[]`, `handoffs[]`, `phases[]`
- `scenario`: รายละเอียด Scenario ที่ทดสอบ
- `evidence_bundle`: หลักฐานจาก Agent ต่างๆ (PoC, screenshots, CLI output)

## Workflow

### 1. Attack Narrative Construction
- เรียงลำดับ attack chain ตาม MITRE ATT&CK Lifecycle:
  - `[TA0043] Recon` → `[TA0001] Initial Access` → `[TA0004] Priv Esc` → `[TA0008] Lateral Movement` → `[TA0040] Impact`
- ระบุ **T-Code** ของแต่ละ step ที่ใช้จริง

### 2. OWASP Top 10 Vulnerability Mapping
- จับคู่ finding แต่ละรายการกับ OWASP category
- คำนวณ OWASP Risk Score (Likelihood × Impact)

### 3. MITRE ATT&CK Technique Mapping
| Technique ID | Technique Name | Evidence |
|--------------|----------------|---------|
| T1595 | Active Scanning | ผล httpx/subfinder |
| T1190 | Exploit Public-Facing App | PoC จาก rt-webops |
| T1059.007 | JavaScript Execution (XSS) | dalfox output |
| T1078 | Valid Accounts | Credential findings |
| ... | ... | ... |

### 4. ISO 27001 C-I-A Risk Assessment
- **Confidentiality:** ข้อมูลอะไรรั่วได้?
- **Integrity:** ข้อมูลอะไรแก้ไขได้?
- **Availability:** ระบบถูก DoS ได้ไหม?

### 5. Detection Gaps Analysis ⭐ (หัวใจหลัก)
สำหรับแต่ละ technique ที่สำเร็จ ให้ตอบ 3 คำถาม:
> **"อะไรควรตรวจพบ? → ทำไมถึงพลาด? → ควรปรับปรุงอย่างไร?"**

ตัวอย่าง:
- **SQLi บน /api/users:** WAF ควรบล็อก → ไม่มี WAF rule สำหรับ encoded payload → เพิ่ม ModSecurity CRS rule #942xxx
- **Subdomain Takeover:** DNS monitoring ควรแจ้งเตือน → ไม่มี CNAME validation → ใช้ dnsx หรือ can-i-take-over-xyz

### 6. Score Breakdown (100 คะแนน)
- Recon Control: XX/20
- Exploit Prevention: XX/30
- Detection Coverage: XX/30
- Response Readiness: XX/20

### 7. Top 3 Mitigation Actions
เรียงตาม Impact/Effort ratio:
1. Quick Win (< 1 วัน)
2. Medium Term (1–2 สัปดาห์)
3. Strategic (1+ เดือน)

## Output Contract
- Attack Narrative พร้อม MITRE T-Code ทุก step
- OWASP + MITRE dual mapping table
- Detection Gaps section — ต้องมีอย่างน้อย 3 gaps
- ISO 27001 C-I-A Assessment
- Score Breakdown (100 คะแนน)
- Top 3 Mitigation Actions

## Safety Guardrails
- **Fact-based Only:** สรุปจากหลักฐานเท่านั้น ห้าม Over-claim
- **Confidentiality:** Report ห้าม share นอก authorized channel
- หากทีมละเมิด scope → หักคะแนนและระบุในรายงาน


# SKILL: retrospective

## Purpose
ประเมินผลการโจมตีทั้งหมดสรุปรวมในภาพใหญ่ สร้าง Attack Chain Report ที่มีรายละเอียดครบถ้วนเพื่อใช้อ้างอิงการลดความเสี่ยง (Mitigation Plan) โดยเชื่อมโยงคะแนนและระดับความเสี่ยงกับ **OWASP Top 10** และ **ISO 27001**.

## Focus Areas
- **Target:** Consolidated Evidence Records from WebOps & Access Phase.
- **Frameworks:** ISO 27001 (Information Security Incident Management, Control & Rectification), OWASP Risk Rating Methodology.

## Required Inputs
- `scenario`: รายละเอียดของ Scenario / ระบบรวมที่ตรวจสอบเสร็จสิ้น.
- `evidence_bundle`: หลักฐานที่รวมมาจาก Agent ต่างๆ.
- `attack_chain`: ลำดับขั้นการตีกุญแจเข้าระบบ.

## Workflow

1. **Timeline & Attack Chain Generation**
   - รวบรวมลำดับเหตุการณ์ (Recon -> Exploitation -> Impact validation).

2. **Risk & Impact Assessment (ISO 27001 & OWASP Alignment)**
   - สรุปความเสี่ยงรวม (Overall Risk Score) อิงจาก Likelihood x Impact.
   - แจกแจงผลกระทบต่อหลัก Confidentiality, Integrity, Availability อย่างเป็นทางการ.
   - ระบุช่องโหว่ OWASP Category ที่จับต้องได้ (เช่น A01, A03, A07).

3. **Remediation Planning**
   - จัดหาแนวทางแก้ไข (Secure Code / Config) ตามมาตรฐานอุตสาหกรรม (OWASP Proactive Controls).

4. **Reporting**
   - จัดทำ Executive Summary และ Technical Details.

## Output Contract
- **Timeline & Attack Chain**
- **Risk Assessment Breakdown & ISO 27001 impact** 
- **Top 3 Remediation Actions**

## Safety Guardrails
- **Confidentiality:** รายงานทั้งหมดห้ามถูกเปิดเผยหรือ Exfiltrate ไปยัง Agent ที่ไม่ได้มีอำนาจตรวจสอบเด็ดขาด.
- **Fact-based Analysis:** ห้ามสรุปความเสี่ยงเกินจริงถ้าไม่มี Evidence รองรับชัดเจน.
