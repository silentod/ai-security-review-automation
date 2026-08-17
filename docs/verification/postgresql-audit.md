# PostgreSQL Persistence and Audit Verification

## Workflow

WF-01 - SaaS AI Intake

## Architecture

Mark Pending Risk Review
  -> Build Persistence Record

Mark Assessment Complete
  -> Build Persistence Record

Build Persistence Record
  -> Persist Assessment and Audit Event
  -> PostgreSQL

## Database Objects

Schema:

ai_grc

Tables:

- ai_grc.review_requests
- ai_grc.review_events

## Access Control

The dedicated application role is:

ai_grc_app

Permissions:

review_requests:
- SELECT
- INSERT
- UPDATE

review_events:
- SELECT
- INSERT
- no UPDATE
- no DELETE

## Low-Risk Persistence Test

Service:

PublicWriter AI

Result:

- status = ASSESSMENT_COMPLETE: PASS
- review_queue = standard_review: PASS
- rule_score = 0: PASS
- rule_risk_level = low: PASS
- ai_recommended_risk_level = low: PASS
- triage_risk_level = low: PASS
- requires_human_review = false: PASS
- RISK_ASSESSMENT_COMPLETED event created: PASS

## High-Risk Persistence Test

Service:

AdminAnalytics AI

Result:

- status = PENDING_HUMAN_RISK_REVIEW: PASS
- review_queue = security_risk_review: PASS
- rule_score = 100: PASS
- rule_risk_level = high: PASS
- ai_recommended_risk_level = high: PASS
- triage_risk_level = high: PASS
- requires_human_review = true: PASS
- HUMAN_RISK_REVIEW_QUEUED event created: PASS

## Idempotency Test

The same low-risk persistence operation was executed twice.

Expected behavior:

- review_requests is upserted by request_id
- duplicate review_events row is not created
- audit_event_inserted = false on retry
- event_count remains 1 for the request

Result:

PASS

## Payload Minimization

Only the redacted and minimized llm_payload is stored
as request_payload.

Verification:

- requester_email absent from request_payload: PASS
- request_id absent from request_payload: PASS

## Audit Event Protection

The ai_grc_app role attempted UPDATE on review_events.

Expected result:

permission denied

Result:

PASS

The ai_grc_app role attempted DELETE on review_events.

Expected result:

permission denied

Result:

PASS

## Security Controls

- Dedicated least-privilege database role: PASS
- Parameterized PostgreSQL query: PASS
- Database password stored only in .env: PASS
- .env excluded from Git: PASS
- Audit event UPDATE denied: PASS
- Audit event DELETE denied: PASS
- Duplicate audit events prevented: PASS
- Redacted minimized payload persisted: PASS
- Synthetic test data only: PASS

## Governance

Database persistence does not approve a request.

ASSESSMENT_COMPLETE means automated assessment
and reconciliation have completed.

PENDING_HUMAN_RISK_REVIEW means a human security
reviewer must evaluate the request.

Final approval or rejection remains a human decision.

## Result

PostgreSQL persistence and audit verification: PASS
