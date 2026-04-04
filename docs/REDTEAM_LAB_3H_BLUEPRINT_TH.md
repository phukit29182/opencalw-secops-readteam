# Web/API SecOps Assessment Blueprint (3 ชั่วโมง)

เป้าหมาย: ให้ทีมประเมินจบ 1 Assessment Scope ภายใน 180 นาที ได้ทั้ง PoC, Impact Assessment (ISO 27001), และ Mitigation Report (OWASP Top 10)

---

## Timebox มาตรฐาน

| Phase | เวลา | Agent | เป้าหมาย |
|-------|------|-------|----------|
| Kickoff + Scope | T+00 → T+15 | `rt-lead` | ISO 27001 Rules of Engagement |
| Recon | T+15 → T+55 | `rt-recon` | Kali Asset Discovery → Attack paths |
| WebOps | T+55 → T+115 | `rt-webops` | OWASP PoC ด้วย Kali Tools |
| Access/Impact | T+115 → T+150 | `rt-access` | C-I-A Impact Assessment |
| Debrief | T+150 → T+180 | `rt-debrief` | Report + Score + Mitigation |

---

## Scoring (100 คะแนน)

| เกณฑ์ | คะแนน |
|-------|-------|
| Recon Quality (Asset coverage) | 20 |
| Exploit Reproducibility (PoC + Kali CLI) | 30 |
| Impact Proof (C-I-A assessment) | 20 |
| Evidence Quality (OWASP mapping ชัดเจน) | 15 |
| Defensive Recommendations (Web/API fixes) | 10 |
| Time Discipline | 5 |

**Penalty:**
- ขอ hint: `-5` ต่อครั้ง (สูงสุด `-20`)
- ละเมิด scope (ISO 27001): **fail ทันที**

---

## Scenario Pack

| Scenario | ระดับ | OWASP Focus |
|----------|-------|-------------|
| `web-lab-sqli-basic` | ง่าย | A03:2021-Injection |
| `web-lab-authz-bypass` | กลาง | A01:2021-Broken Access, A07:2021-Auth |
| `web-lab-ssrf-pivot` | กลาง-สูง | A10:2021-SSRF |
| `web-lab-client-attacks` | กลาง | A03:2021-Injection (Client-Side) |

---

## Deliverable บังคับตอนจบ

1. Attack Timeline
2. คำสั่ง Kali + หลักฐานที่ reproduce ได้
3. Root Cause Analysis
4. **OWASP Top 10 Mapping** ≥ 3 categories
5. Mitigation Quick Wins 3 ข้อ (Web/API defenses)
