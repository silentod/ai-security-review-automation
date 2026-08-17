# Deterministic Risk Reconciliation Verification

## Workflow

WF-01 - SaaS AI Intake

## Architecture

Mark Ready for AI
  -> Calculate Deterministic Risk
  -> AI Security Assessment
  -> Mark AI Assessed
  -> Reconcile Risk Signals
  -> Human Review Required?
     -> True: Mark Pending Risk Review
     -> False: Mark Assessment Complete

## Deterministic Rule Engine

The rule engine calculates:

- numeric risk score
- rule risk level
- score reasons
- hard review flags
- human review requirement

Risk bands:

- low: 0-24
- medium: 25-69
- high: 70-100

Medium and high rule results require human review.

The final score is capped at 100 while raw_score preserves
the uncapped calculated value.

## Reconciliation

The AI assessment remains advisory.

The triage risk level is the higher of:

- deterministic rule risk level
- AI recommended risk level

The AI cannot lower the deterministic policy floor.

Human review is required when:

- the rule engine requires review
- the AI recommends review
- the risk levels disagree
- the human-review recommendations disagree
- the triage risk level is high

Automatic approval is not performed.

## Low-Risk Test

Service:

PublicWriter AI

Input characteristics:

- public data only
- access_level = none
- model_training = no
- sso_available = yes
- audit_logs = yes
- data_region = Japan
- deletion_supported = yes
- business_criticality = low

Rule result:

- raw_score = 0: PASS
- score = 0: PASS
- risk_level = low: PASS
- requires_human_review = false: PASS
- hard_review_flags empty: PASS

AI result:

- recommended_risk_level = low: PASS
- requires_human_review = false: PASS

Reconciliation result:

- rule_risk_level = low: PASS
- ai_recommended_risk_level = low: PASS
- triage_risk_level = low: PASS
- level_disagreement = false: PASS
- human_review_disagreement = false: PASS
- review_required = false: PASS
- automatic_approval = false: PASS

Final routing:

- Human Review Required? false branch: PASS
- status = ASSESSMENT_COMPLETE: PASS
- review_queue = standard_review: PASS

ASSESSMENT_COMPLETE does not mean APPROVED.

## High-Risk Test

Service:

AdminAnalytics AI

Input characteristics:

- confidential and personal data
- access_level = admin
- model_training = yes
- sso_available = no
- audit_logs = no
- data_region = Unknown
- deletion_supported = unknown
- business_criticality = high

Rule result:

- raw_score = 121: PASS
- capped score = 100: PASS
- risk_level = high: PASS
- requires_human_review = true: PASS

Hard review flags:

- ADMIN_WITH_SENSITIVE_DATA: PASS
- TRAINING_WITH_SENSITIVE_DATA: PASS
- HIGH_CRITICALITY_WITHOUT_AUDIT_LOGS: PASS

AI result:

- recommended_risk_level = high: PASS
- requires_human_review = true: PASS

Reconciliation result:

- rule_risk_level = high: PASS
- ai_recommended_risk_level = high: PASS
- triage_risk_level = high: PASS
- level_gap = 0: PASS
- level_disagreement = false: PASS
- human_review_disagreement = false: PASS
- review_required = true: PASS
- automatic_approval = false: PASS

Review reasons:

- RULE_ENGINE_REQUIRES_REVIEW
- AI_RECOMMENDS_REVIEW
- HIGH_TRIAGE_RISK

Final routing:

- Human Review Required? true branch: PASS
- status = PENDING_HUMAN_RISK_REVIEW: PASS
- review_queue = security_risk_review: PASS

## Governance

Deterministic controls and LLM judgment remain separate.

The deterministic rule engine is repeatable and auditable.

The LLM provides contextual advisory analysis.

The LLM does not receive rule_assessment as part of llm_payload,
preventing the deterministic score from biasing the AI assessment.

Disagreement is escalated rather than silently resolved.

The AI cannot lower the deterministic policy floor.

No automatic approval is performed.

Final approval or rejection remains a human decision.

## Versions

- deterministic rule engine: 1.0.0
- reconciliation logic: 1.0.0
- AI prompt: 1.0.0
- AI output schema: 1.0.0

## Result

Deterministic risk scoring and reconciliation verification: PASS
