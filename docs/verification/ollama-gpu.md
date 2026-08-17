# Local Ollama GPU Verification

## Environment

- Ollama version: 0.32.13
- GPU: NVIDIA GeForce RTX 2070
- GPU memory: 8192 MiB
- Model: qwen3:4b-instruct-2507-q4_K_M
- Model quantization: Q4_K_M
- Context length: 4096

## Local Model Verification

- Model download: PASS
- Japanese inference from PowerShell: PASS
- Ollama API on localhost:11434: PASS
- Ollama cloud disabled: PASS
- OLLAMA_NO_CLOUD: enabled
- GPU offload: 100% GPU

## n8n Integration

- Ollama runs natively on Windows.
- n8n runs inside Docker Desktop.
- n8n connects to Ollama through:
  http://host.docker.internal:11434
- Ollama credential connection test: PASS
- Credential HTTP domain restriction:
  host.docker.internal
- API key: not required
- n8n -> Ollama API connectivity: PASS
- n8n -> Qwen3 Japanese inference: PASS

## Smoke Test Workflow

Workflow:

Ollama GPU Smoke Test

Flow:

Manual Trigger
  -> Ollama "Message a model"
  -> qwen3:4b-instruct-2507-q4_K_M

Test use case:

Summarize a security review request involving generative AI,
with no personal information and no external system integration.

Result:

- Japanese response returned successfully: PASS
- GPU processor after n8n inference: 100% GPU
- Workflow export validation: PASS
- Obvious secret fields in exported workflow: NONE FOUND

## Security Design

- Local LLM is used instead of an external generative AI API.
- Ollama cloud functionality is disabled.
- Ollama API is not configured with an external cloud API key.
- n8n credential access is restricted to host.docker.internal.
- Workflow export does not contain passwords or API keys.
- Real customer or employer data is not used.

## Result

Local LLM and n8n integration verification: PASS
