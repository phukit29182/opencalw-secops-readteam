#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_PATH="${ROOT_DIR}/config-snippets/openclaw.rt-training.example.json"
ENV_PATH="${ROOT_DIR}/config-snippets/rt-training.env"
OUTPUT_PATH="${ROOT_DIR}/config-snippets/openclaw.rt-training.generated.json"
FORCE="false"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/instantiate-config.sh [--env <path>] [--output <path>] [--force]

Options:
  --env <path>     Path to env file (default: config-snippets/rt-training.env)
  --output <path>  Output config path (default: config-snippets/openclaw.rt-training.generated.json)
  --force          Overwrite output file if it exists
  -h, --help       Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env)
      ENV_PATH="$2"
      shift 2
      ;;
    --output)
      OUTPUT_PATH="$2"
      shift 2
      ;;
    --force)
      FORCE="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -f "$TEMPLATE_PATH" ]]; then
  echo "Template not found: $TEMPLATE_PATH" >&2
  exit 1
fi

if [[ ! -f "$ENV_PATH" ]]; then
  echo "Env file not found: $ENV_PATH" >&2
  echo "Copy config-snippets/rt-training.env.example to $ENV_PATH and fill values." >&2
  exit 1
fi

if [[ -f "$OUTPUT_PATH" && "$FORCE" != "true" ]]; then
  echo "Output exists: $OUTPUT_PATH" >&2
  echo "Use --force to overwrite." >&2
  exit 1
fi

python3 - "$TEMPLATE_PATH" "$ENV_PATH" "$OUTPUT_PATH" <<'PY'
import json
import pathlib
import re
import sys

template_path = pathlib.Path(sys.argv[1])
env_path = pathlib.Path(sys.argv[2])
output_path = pathlib.Path(sys.argv[3])

required_keys = [
    "REPLACE_OPENCLAW_GATEWAY_TOKEN",
    "REPLACE_TELEGRAM_BOT_TOKEN_MAIN",
    "REPLACE_TRAINING_GROUP_ID",
    "REPLACE_TRAINER_USER_ID",
    "REPLACE_TOPIC_ID_LEAD",
    "REPLACE_TOPIC_ID_RECON",
    "REPLACE_TOPIC_ID_WEBOPS",
    "REPLACE_TOPIC_ID_ACCESS",
    "REPLACE_TOPIC_ID_DEBRIEF",
]

values = {}
for raw in env_path.read_text(encoding="utf-8").splitlines():
    line = raw.strip()
    if not line or line.startswith("#"):
        continue
    if "=" not in line:
        raise SystemExit(f"Invalid env line: {raw}")
    k, v = line.split("=", 1)
    values[k.strip()] = v.strip()

missing = [k for k in required_keys if not values.get(k)]
if missing:
    raise SystemExit("Missing required env keys: " + ", ".join(missing))

payload = json.loads(template_path.read_text(encoding="utf-8"))
placeholder_pattern = re.compile(r"^REPLACE_[A-Z0-9_]+$")


def replace_in_string(s: str) -> str:
    """Substitute any REPLACE_* token embedded in a string (e.g. JSON object keys)."""
    if not isinstance(s, str):
        return s
    out = s
    for k, v in values.items():
        if k in out:
            out = out.replace(k, v)
    return out


def replace(obj):
    if isinstance(obj, dict):
        return {replace_in_string(k): replace(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [replace(v) for v in obj]
    if isinstance(obj, str) and placeholder_pattern.match(obj):
        return values.get(obj, obj)
    return obj

rendered = replace(payload)
output_path.parent.mkdir(parents=True, exist_ok=True)
output_path.write_text(json.dumps(rendered, indent=2) + "\n", encoding="utf-8")
print(f"Generated: {output_path}")
PY

echo
echo "Next step:"
echo "  cp \"$OUTPUT_PATH\" ~/.openclaw/openclaw.json"
