# Local llama.cpp serving setup for the Pi coding agent.
#
# Provides a `llama-pi-serve` wrapper that starts Qwen3.5 9B (Q4_K_M) with full
# GPU offload for the 8 GB dGPU on `moreno`, exposing the OpenAI-compatible
# endpoint that pi-llama auto-discovers at http://localhost:8080/v1.
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
      CTX="''${1:-4096}"
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
        -ngl 999 -c "$CTX" --flash-attn on \
        --cache-type-k q8_0 --cache-type-v q8_0 \
        --port "$PORT" > /tmp/llama-serve.log 2>&1 &

      echo "Starting $MODEL on :$PORT (ctx=$CTX, full GPU offload)..."

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
