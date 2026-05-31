#!/usr/bin/env bash
# ─────────────────────────────────────────────
#  Switch Copilot CLI to NIM or OpenRouter
#  Usage: source ./copilotMOD.sh <provider> [model]
#
#  Examples:
#    source ./copilotMOD.sh nim
#    source ./copilotMOD.sh nim deepseek-ai/deepseek-v4-pro
#    source ./copilotMOD.sh openrouter
#    source ./copilotMOD.sh openrouter deepseek/deepseek-r1
# ─────────────────────────────────────────────

PROVIDER="${1:-}"
MODEL="${2:-}"

# ── usage ─────────────────────────────────────
if [[ -z "$PROVIDER" ]]; then
  echo "Usage: source ./copilotMOD.sh <provider> [model]"
  echo "  Providers: nim, openrouter"
  echo ""
  echo "  Examples:"
  echo "    source ./copilotMOD.sh nim"
  echo "    source ./copilotMOD.sh nim deepseek-ai/deepseek-v4-pro"
  echo "    source ./copilotMOD.sh openrouter"
  echo "    source ./copilotMOD.sh openrouter deepseek/deepseek-r1"
  return 0 2>/dev/null || exit 0
fi

# ── provider config ───────────────────────────
case "$PROVIDER" in

  nim)
    DEFAULT_MODEL="qwen/qwen3-coder-480b-a35b-instruct"
    MODEL="${MODEL:-$DEFAULT_MODEL}"

    if [[ -z "$NVIDIA_NIM_API_KEY" ]]; then
      echo "⚠️  NVIDIA_NIM_API_KEY is not set."
      echo "    Export it first:  export NVIDIA_NIM_API_KEY=nvapi-xxxx"
      return 1 2>/dev/null || exit 1
    fi

    export COPILOT_PROVIDER_BASE_URL="https://integrate.api.nvidia.com/v1"
    export COPILOT_PROVIDER_API_KEY="$NVIDIA_NIM_API_KEY"
    export COPILOT_MODEL="$MODEL"

    echo "✅ Copilot CLI → NVIDIA NIM"
    ;;

  openrouter)
    DEFAULT_MODEL="minimax/minimax-m2.5:free"
    MODEL="${MODEL:-$DEFAULT_MODEL}"

    if [[ -z "$OPENROUTER_API_KEY" ]]; then
      echo "⚠️  OPENROUTER_API_KEY is not set."
      echo "    Export it first:  export OPENROUTER_API_KEY=sk-or-xxxx"
      return 1 2>/dev/null || exit 1
    fi

    export COPILOT_PROVIDER_BASE_URL="https://openrouter.ai/api/v1"
    export COPILOT_PROVIDER_API_KEY="$OPENROUTER_API_KEY"
    export COPILOT_MODEL="$MODEL"

    echo "✅ Copilot CLI → OpenRouter"
    ;;

  *)
    echo "❌ Unknown provider: '$PROVIDER'"
    echo "   Supported: nim, openrouter"
    return 1 2>/dev/null || exit 1
    ;;

esac

echo "   Model : $COPILOT_MODEL"
echo "   URL   : $COPILOT_PROVIDER_BASE_URL"
echo ""
echo "   Run:  copilot"
