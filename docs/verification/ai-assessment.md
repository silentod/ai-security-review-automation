# AI Security Assessment Verification

## Workflow

WF-01 - SaaS AI Intake

## Architecture

Validated request
  -> Mark Ready for AI
  -> AI Security Assessment
     -> Ollama Chat Model
     -> Structured Output Parser
  -> Mark AI Assessed

## Model

- Provider: Local Ollama
- Model: qwen3:4b-instruct-2507-q4_K_M
- Temperature: 0
- Cloud dependency: disabled
- Local GPU execution previously verified

## Input Boundary

Only requests that pass the input validation, redaction, and routing controls are routed to AI.

Required conditions include:

- validation.valid = true
- secret_hits = empty
- anomaly_flags = empty
- intake_route = ready_for_ai

Only llm_payload is supplied to the model.

## Structured Output

The AI assessment returns:

- summary
- recommended_risk_level
- confidence
- risk_factors
- recommended_controls
- review_questions
- requires_human_review
- rationale

## Low-Risk Test

Service:

PublicWriter AI

Result:

- recommended_risk_level = low: PASS
- requires_human_review = false: PASS
- structured output: PASS
- status = AI_ASSESSED: PASS

## High-Risk Test

Service:

AdminAnalytics AI

Risk signals included:

- confidential data
- personal data
- admin access
- model_training = yes
- SSO unavailable
- audit logs unavailable
- unknown data region
- unknown deletion capability
- high business criticality

Result:

- recommended_risk_level = high: PASS
- requires_human_review = true: PASS
- structured output: PASS
- status = AI_ASSESSED: PASS

## Governance

The LLM provides an advisory recommendation only.

It does not make the final approval or rejection decision.

Prompt version:

1.0.0

Schema version:

1.0.0

## Known Limitation

The local 4B model can occasionally generate interpretations
that go beyond literal request evidence.

Examples observed during testing included:

- inferring monitoring implications from audit_logs
- inferring compliance implications from data_region
- naming a specific regulation not supplied in the request

Prompt controls reduced these issues but did not eliminate them.

Therefore:

- AI output is advisory
- evidence must remain reviewable
- high-risk assessments require human review
- deterministic controls remain separate from LLM judgment

A structured-output formatting failure was also observed once
and succeeded on retry.

## Result

Local AI first-pass security assessment verification: PASS
