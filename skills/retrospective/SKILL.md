---
name: retrospective
description: จัดทำรายงานการประเมินเจาะระบบ อ้างอิงตามระดับความเสี่ยงของ OWASP และผลกระทบต่อ ISO 27001
---

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
