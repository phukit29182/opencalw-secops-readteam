#!/usr/bin/env bash
# ปิด session และแสดงสรุป metrics
# ใช้: ./scripts/close-session.sh <session-id>
# ตัวอย่าง: ./scripts/close-session.sh 2026-03-30-web-lab-sqli-basic

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <session-id>"
  echo "Example: $0 2026-03-30-web-lab-sqli-basic"
  echo ""
  echo "Active sessions:"
  for d in "$REPO_ROOT"/sessions/*/; do
    if [ -f "$d/session_state.json" ]; then
      basename "$d"
    fi
  done
  exit 1
fi

SESSION_ID="$1"
SESSION_FILE="$REPO_ROOT/sessions/$SESSION_ID/session_state.json"

if [ ! -f "$SESSION_FILE" ]; then
  echo "[!] Session not found: $SESSION_FILE"
  exit 1
fi

END_TIME="$(date -Iseconds)"

python3 -c "
import json, sys
from datetime import datetime

with open('$SESSION_FILE', 'r') as f:
    state = json.load(f)

if state.get('current_phase') == 'closed':
    print('[!] Session is already closed.')
    sys.exit(1)

state['ended_at'] = '$END_TIME'
state['current_phase'] = 'closed'

# คำนวณ phase durations
durations = {}
for phase in state.get('phases', []):
    if phase.get('started_at') and phase.get('ended_at'):
        try:
            start = datetime.fromisoformat(phase['started_at'])
            end = datetime.fromisoformat(phase['ended_at'])
            durations[phase['name']] = round((end - start).total_seconds() / 60, 1)
        except:
            pass

# คำนวณ metrics
handoffs = state.get('handoffs', [])
findings = state.get('findings', [])

try:
    session_start = datetime.fromisoformat(state['started_at'])
    session_end = datetime.fromisoformat(state['ended_at'])
    total_minutes = round((session_end - session_start).total_seconds() / 60, 1)
except:
    total_minutes = 0

state['metrics']['phase_durations_minutes'] = durations
state['metrics']['handoff_count'] = len(handoffs)
state['metrics']['findings_count'] = len(findings)
state['metrics']['time_remaining_minutes'] = max(0, state.get('timebox_minutes', 180) - total_minutes)

# คำนวณ total score
score = state.get('score', {})
total = sum(v for k, v in score.items() if k != 'total' and isinstance(v, (int, float)))
total -= state.get('penalties', 0)
state['score']['total'] = max(0, total)

with open('$SESSION_FILE', 'w') as f:
    json.dump(state, f, indent=2, ensure_ascii=False)

# แสดงสรุป
print()
print('=' * 50)
print('  SESSION CLOSED')
print('=' * 50)
print(f'  Session ID    : {state[\"session_id\"]}')
print(f'  Scenario      : {state[\"scenario\"]}')
print(f'  Duration      : {total_minutes} minutes')
print(f'  Timebox       : {state.get(\"timebox_minutes\", 180)} minutes')
overtime = total_minutes - state.get('timebox_minutes', 180)
if overtime > 0:
    print(f'  OVERTIME      : +{overtime} minutes')
else:
    print(f'  Time Remaining: {abs(overtime)} minutes')
print()
print('--- Metrics ---')
print(f'  Handoffs      : {len(handoffs)}')
print(f'  Findings      : {len(findings)}')
print(f'  Hints Used    : {state.get(\"hints_used\", 0)}')
print(f'  Penalties     : -{state.get(\"penalties\", 0)}')
print()
print('--- Phase Durations ---')
for name, dur in durations.items():
    print(f'  {name:12s}: {dur} min')
print()
print('--- Score ---')
for k, v in state.get('score', {}).items():
    if k != 'total':
        print(f'  {k:30s}: {v}')
print(f'  {\"TOTAL\":30s}: {state[\"score\"][\"total\"]}')
print()
print('=' * 50)
print(f'  Full state: $SESSION_FILE')
print('=' * 50)
"
