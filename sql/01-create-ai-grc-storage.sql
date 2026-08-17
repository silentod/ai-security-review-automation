BEGIN;

CREATE SCHEMA IF NOT EXISTS ai_grc;

REVOKE ALL
ON SCHEMA ai_grc
FROM PUBLIC;

CREATE TABLE IF NOT EXISTS ai_grc.review_requests (
  request_id text PRIMARY KEY,

  received_at timestamptz NOT NULL,
  submitted_at timestamptz,

  requester_email text NOT NULL,
  service_name text NOT NULL,
  service_category text NOT NULL,

  status text NOT NULL,
  review_queue text NOT NULL,

  rule_score integer NOT NULL
    CHECK (
      rule_score BETWEEN 0 AND 100
    ),

  rule_risk_level text NOT NULL
    CHECK (
      rule_risk_level IN (
        'low',
        'medium',
        'high'
      )
    ),

  ai_recommended_risk_level text NOT NULL
    CHECK (
      ai_recommended_risk_level IN (
        'low',
        'medium',
        'high'
      )
    ),

  triage_risk_level text NOT NULL
    CHECK (
      triage_risk_level IN (
        'low',
        'medium',
        'high'
      )
    ),

  requires_human_review boolean NOT NULL,

  rule_version text NOT NULL,
  prompt_version text NOT NULL,

  ai_model text NOT NULL,
  ai_assessed_at timestamptz NOT NULL,

  source text NOT NULL,
  workflow_execution_id text NOT NULL,

  request_payload jsonb NOT NULL
    CHECK (
      jsonb_typeof(request_payload) = 'object'
    ),

  rule_assessment jsonb NOT NULL
    CHECK (
      jsonb_typeof(rule_assessment) = 'object'
    ),

  ai_assessment jsonb NOT NULL
    CHECK (
      jsonb_typeof(ai_assessment) = 'object'
    ),

  assessment_comparison jsonb NOT NULL
    CHECK (
      jsonb_typeof(assessment_comparison) = 'object'
    ),

  created_at timestamptz NOT NULL
    DEFAULT now(),

  updated_at timestamptz NOT NULL
    DEFAULT now()
);

CREATE INDEX IF NOT EXISTS
  review_requests_status_idx
ON ai_grc.review_requests (
  status
);

CREATE INDEX IF NOT EXISTS
  review_requests_review_queue_idx
ON ai_grc.review_requests (
  review_queue
);

CREATE INDEX IF NOT EXISTS
  review_requests_triage_risk_idx
ON ai_grc.review_requests (
  triage_risk_level
);

CREATE INDEX IF NOT EXISTS
  review_requests_updated_at_idx
ON ai_grc.review_requests (
  updated_at DESC
);

CREATE TABLE IF NOT EXISTS ai_grc.review_events (
  event_id bigint
    GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,

  event_key text NOT NULL UNIQUE,

  request_id text NOT NULL
    REFERENCES ai_grc.review_requests (
      request_id
    )
    ON DELETE RESTRICT,

  event_type text NOT NULL,

  status text NOT NULL,
  review_queue text NOT NULL,

  actor_type text NOT NULL,
  actor_id text NOT NULL,

  workflow_execution_id text NOT NULL,

  event_at timestamptz NOT NULL,

  details jsonb NOT NULL
    CHECK (
      jsonb_typeof(details) = 'object'
    ),

  created_at timestamptz NOT NULL
    DEFAULT now()
);

CREATE INDEX IF NOT EXISTS
  review_events_request_id_idx
ON ai_grc.review_events (
  request_id
);

CREATE INDEX IF NOT EXISTS
  review_events_event_at_idx
ON ai_grc.review_events (
  event_at DESC
);

REVOKE ALL
ON TABLE ai_grc.review_requests
FROM PUBLIC;

REVOKE ALL
ON TABLE ai_grc.review_events
FROM PUBLIC;

GRANT USAGE
ON SCHEMA ai_grc
TO ai_grc_app;

GRANT
  SELECT,
  INSERT,
  UPDATE
ON TABLE ai_grc.review_requests
TO ai_grc_app;

GRANT
  SELECT,
  INSERT
ON TABLE ai_grc.review_events
TO ai_grc_app;

GRANT
  USAGE,
  SELECT
ON ALL SEQUENCES IN SCHEMA ai_grc
TO ai_grc_app;

COMMIT;
