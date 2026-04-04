# Skill: graphql-introspection

## Meta
- **ID:** `graphql-introspection`
- **Agent:** `rt-recon` / `rt-webops`
- **OWASP API:** API9:2023 — Improper Inventory Management
- **Kali Tools:** curl, graphql-cop, InQL (Burp), clairvoyance
- **ISO 27001:** Confidentiality impact assessment

## Objective
ทดสอบว่า GraphQL API เปิด introspection query ให้ดึง schema ทั้งหมดได้หรือไม่ และมี deprecated/hidden endpoints ที่ไม่ควรเปิดหรือไม่

## Steps
1. ตรวจว่า target ใช้ GraphQL: `POST /graphql` with `{"query":"{__typename}"}`
2. รัน introspection query: `{"query":"{__schema{types{name fields{name}}}}"}`
3. วิเคราะห์ schema: ค้นหา sensitive types (User, Admin, Config, Secret)
4. ค้นหา mutations ที่ไม่มี authorization
5. ถ้า introspection ถูกปิด → ใช้ clairvoyance/field suggestion brute force
6. PoC: แสดง full schema + sensitive endpoints ที่ไม่ควรเปิด

## Constraints
- Read-only queries เท่านั้น (ไม่รัน mutations ที่เปลี่ยนข้อมูล)
- ห้ามดึงข้อมูลจริงจำนวนมาก (limit ≤ 5 records)
- PoC ระดับแสดง schema เท่านั้น

## Evidence Required
- Introspection query + response (ย่อ)
- Sensitive types/fields ที่ค้นพบ
- Mutations ที่ไม่มี auth guard
- OWASP API9:2023 mapping
- CIA Impact: Confidentiality HIGH (schema leak)
