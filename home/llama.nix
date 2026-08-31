# Local llama.cpp serving setup for the Pi coding agent.
#
# Provides a `llama-pi-serve` wrapper that starts Qwen3.5 9B (Q4_K_M), with the
# model weights fully offloaded to the 8 GB dGPU on `moreno` but the KV cache
# kept in system RAM (--no-kv-offload). This is required because pi sends a
# ~24k-token system prompt, so a large context (~32k) is needed, and a fully
# GPU-resident KV cache for that size would exceed the available VRAM.
# Exposes the OpenAI-compatible endpoint pi-llama auto-discovers at
# http://localhost:8080/v1. Accepts an optional context size as arg 1.
{
  pkgs,
  ...
}:

let
  llama = "${pkgs.llama-cpp}/bin/llama-server";
in
{
  # Install llama.cpp, and provide a `llama-pi-serve` wrapper that prefers the
  # NixOS binary but falls back to a manual ~/.local/bin install if needed.
  home.packages = with pkgs; [
    llama-cpp
    (pkgs.writeShellScriptBin "llama-pi-serve" ''
      set -euo pipefail

      PORT="''${PORT:-8080}"
      CTX="''${1:-32768}"
      MODEL="unsloth/Qwen3.5-9B-MTP-GGUF:Q4_K_M"

      LLAMA_BIN="${llama}"
      if [ ! -x "$LLAMA_BIN" ]; then
        LLAMA_BIN="$HOME/.local/bin/llama"
      fi

      pkill -9 -f "llama serve" 2>/dev/null || true
      sleep 1

      nohup "$LLAMA_BIN" serve \
        --hf-repo "$MODEL" \
        --alias "$MODEL" \
        -ngl 999 --no-kv-offload -c "$CTX" --flash-attn on \
        --cache-type-k q8_0 --cache-type-v q8_0 \
        --port "$PORT" > /tmp/llama-serve.log 2>&1 &

      echo "Starting $MODEL on :$PORT (ctx=$CTX, weights=GPU KV=RAM)..."

      for i in $(seq 1 30); do
        if curl -s -m 2 "http://localhost:$PORT/v1/models" >/dev/null 2>&1; then
          echo "OK: ready at http://localhost:$PORT/v1"
          exit 0
        fi
        sleep 1
      done
      echo "Not ready after 30s - check /tmp/llama-serve.log" >&2
      exit 1
    '')
  ];
}
