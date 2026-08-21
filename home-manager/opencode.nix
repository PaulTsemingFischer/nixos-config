{ ... }:
{
  # Local models are served by the system-wide `services.ollama` (see
  # nixos/configuration.nix), which declaratively pulls the models listed
  # below via `services.ollama.loadModels`. Selected from a 10-model
  # benchmark run on this laptop's specs (RTX 4060 Laptop 8GB VRAM + 32GB
  # RAM) -- full methodology, transcripts and the two models that got cut
  # (devstral:24b, command-r7b:7b) are in ~/opencode-benchmark/RESULTS.md.
  #
  # Agent-capable (tool_call = true -- these reliably drive opencode's
  # tools):
  #   - gpt-oss:20b      DEFAULT. Best real-world agent in testing: a
  #     multi-turn benchmark with real tool execution (not just single-shot
  #     tool selection) scored it a perfect 18/18, beating every other
  #     model tried, with zero hallucinated tools and zero timeouts. Tends
  #     to explore first (grep/read) before acting, which is more careful
  #     than it looks on a naive single-shot test.
  #   - llama3.1:8b      Fastest agent by far (~1.2s avg tool-call latency
  #     vs gpt-oss's ~4s), 17/18 on the same multi-turn benchmark. Its one
  #     miss: read a file to investigate, then stopped without following
  #     through on the actual edit -- worth a nudge if it seems to stall.
  #     Good pick when you want speed over gpt-oss's extra carefulness.
  #   - qwen3:8b         Perfect single-shot tool-call score and the most
  #     disciplined at following output-length instructions, but that
  #     didn't hold up multi-turn: dropped to 15/18 with two flat-out 120s
  #     timeouts and a search task where it burned all its turns on
  #     malformed regex syntax. Fine for lower-stakes use, riskier as a
  #     primary driver.
  #   - mistral-nemo:12b Solid general-purpose agent (21/24 single-shot),
  #     fast (~2s avg). Occasionally goes silent (empty response, no tool
  #     call) instead of acting.
  #   - qwen2.5-coder:7b SMALL_MODEL. Fastest raw throughput (49 tok/s), used
  #     for cheap tasks like title generation that rarely need tool calls.
  #     Don't promote to primary: under opencode's full ~10-tool schema it
  #     reliably leaks well-formed tool calls as plain JSON text instead of
  #     using the structured tool_calls field (a real Ollama parsing
  #     limitation, confirmed by inspecting raw responses).
  #
  # Chat-only (tool_call = false -- select manually for conversation/code
  # Q&A, not agentic tasks; these either can't reliably call tools or can't
  # call them at all):
  #   - qwen3-coder:30b  Biggest/strongest raw coding model in the set, but
  #     Ollama's parsing of its tool-call output is flaky (~40-60% failure
  #     rate in repeated testing -- valid tool calls leak as raw
  #     "<function=...>" XML text instead of a real tool_calls entry).
  #     Good for direct code-writing questions where you don't need it to
  #     touch files itself.
  #   - phi4:14b         Doesn't support tool calling at all --
  #     `ollama show phi4:14b` lists only the `completion` capability, and
  #     Ollama hard-rejects any request with tools attached. Kept for
  #     Phi-4's reasoning/chat quality, not as an agent option.
  #   - deepseek-r1:8b   Reasoning/thinking model. Tool-calling is
  #     essentially broken here (1/24 in testing -- mostly 120s timeouts or
  #     a hard Ollama server error, "output does not match the expected
  #     peg-native format") and it's slow (~130s avg even on non-tool
  #     tasks). Kept for deliberate step-by-step reasoning chat where
  #     you're not in a hurry and don't need it touching files.
  xdg.configFile."opencode/opencode.jsonc".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider.ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options.baseURL = "http://localhost:11434/v1";
      models = {
        "gpt-oss:20b" = {
          name = "GPT-OSS 20B (local)";
          tool_call = true;
          reasoning = true;
          limit.context = 65536;
          limit.output = 8192;
          options.num_ctx = 65536;
        };
        "llama3.1:8b" = {
          name = "Llama 3.1 8B (local)";
          tool_call = true;
          reasoning = false;
          limit.context = 32768;
          limit.output = 4096;
          options.num_ctx = 32768;
        };
        "qwen3:8b" = {
          name = "Qwen3 8B (local)";
          tool_call = true;
          reasoning = true;
          limit.context = 32768;
          limit.output = 8192;
          options.num_ctx = 32768;
        };
        "mistral-nemo:12b" = {
          name = "Mistral Nemo 12B (local)";
          tool_call = true;
          reasoning = false;
          limit.context = 32768;
          limit.output = 4096;
          options.num_ctx = 32768;
        };
        "qwen2.5-coder:7b" = {
          name = "Qwen2.5 Coder 7B (local)";
          tool_call = true;
          reasoning = false;
          limit.context = 32768;
          limit.output = 8192;
          options.num_ctx = 32768;
        };
        # tool_call = false below: not just documentation -- this stops
        # opencode from ever handing these models a tool schema, so picking
        # one manually falls back to plain chat instead of risking a broken
        # or hard-rejected tool call.
        "qwen3-coder:30b" = {
          name = "Qwen3 Coder 30B (local, chat only)";
          tool_call = false;
          reasoning = false;
          limit.context = 65536;
          limit.output = 8192;
          options.num_ctx = 65536;
        };
        "phi4:14b" = {
          name = "Phi-4 14B (local, chat only)";
          tool_call = false;
          reasoning = false;
          limit.context = 16384;
          limit.output = 4096;
          options.num_ctx = 16384;
        };
        "deepseek-r1:8b" = {
          name = "DeepSeek R1 8B (local, chat only, slow)";
          tool_call = false;
          reasoning = true;
          limit.context = 32768;
          limit.output = 8192;
          options.num_ctx = 32768;
        };
      };
    };
    model = "ollama/gpt-oss:20b";
    small_model = "ollama/qwen2.5-coder:7b";

    # These local models aren't reliable at composing the `task` tool's
    # `subagent_type` parameter (e.g. qwen3-coder:30b hallucinates a
    # standalone "explore" tool instead of calling task(subagent_type:
    # "explore")). Disabling the `task` tool forces flat bash/glob/grep/read
    # usage instead, which they handle correctly.
    tools.task = false;
  };
}
