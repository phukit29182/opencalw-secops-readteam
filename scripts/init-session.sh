#!/usr/bin/env bash
# สร้าง session ใหม่จาก template
# ใช้: ./scripts/init-session.sh <scenario-id>
# ตัวอย่าง: ./scripts/init-session.sh web-lab-sqli-basic

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$REPO_ROOT/sessions/session_state.template.json"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <scenario-id>"
  echo "Example: $0 web-lab-sqli-basic"
  exit 1
fi

SCENARIO="$1"
SESSION_ID="$(date +%Y-%m-%d)-${SCENARIO}"
SESSION_DIR="$REPO_ROOT/sessions/$SESSION_ID"

if [ -d "$SESSION_DIR" ]; then
  echo "[!] Session already exists: $SESSION_DIR"
  echo "    ถ้าต้องการเริ่มใหม่ ให้ลบ folder นี้ก่อน"
  exit 1
fi

mkdir -p "$SESSION_DIR"

START_TIME="$(date -Iseconds)"

python3 -c "
import json, sys

with open('$TEMPLATE', 'r') as f:
    state = json.load(f)

state['session_id'] = '$SESSION_ID'
state['scenario'] = '$SCENARIO'
state['started_at'] = '$START_TIME'
state['current_phase'] = 'kickoff'
state['phases'][0]['status'] = 'active'
state['phases'][0]['started_at'] = '$START_TIME'
state['metrics']['time_remaining_minutes'] = state['timebox_minutes']

with open('$SESSION_DIR/session_state.json', 'w') as f:
    json.dump(state, f, indent=2, ensure_ascii=False)

print(json.dumps(state, indent=2, ensure_ascii=False))
"

echo ""
echo "====================================="
echo "  Session created: $SESSION_ID"
echo "  Path: $SESSION_DIR/session_state.json"
echo "  Scenario: $SCENARIO"
echo "  Started: $START_TIME"
echo "  Timebox: 180 minutes"
echo "====================================="
echo ""
echo "Next steps:"
echo "  1. แจ้งทีมใน Telegram topic rt-lead"
echo "  2. สั่ง rt-recon เริ่ม recon phase"
echo "  3. ใช้ prompt จาก skills/PROMPTS.md"
