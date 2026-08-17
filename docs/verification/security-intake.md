# Security Intake Form Verification

## Workflow

WF-01 - SaaS AI Intake

## Purpose

Receive synthetic external SaaS and generative AI security review
requests through an n8n form and add intake metadata for downstream
validation and risk assessment.

## Flow

On form submission
  -> Add Intake Metadata

## Form Fields

The intake form contains the following fields:

- requester_email
- service_name
- service_category
- use_case
- data_types
- access_level
- model_training
- sso_available
- audit_logs
- data_region
- deletion_supported
- business_criticality
- evidence_notes

## Form Verification

- Email input validation: PASS
- Required fields: PASS
- Dropdown inputs: PASS
- Optional fields: PASS
- Multiple checkbox selection: PASS
- Custom field names used as JSON keys: PASS

## Multi-Select Verification

The Data Types field was tested with multiple selections:

- internal
- confidential

The values were returned as a JSON array: PASS

## Intake Metadata

The Add Intake Metadata node adds:

- request_id
- received_at
- status
- rule_version
- prompt_version
- source

Verified values:

- Request ID generation: PASS
- received_at uses form submittedAt timestamp: PASS
- Initial status: RECEIVED
- Rule version: 1.0.0
- Prompt version: 1.0.0
- Source: n8n_form

## End-to-End Verification

Test flow:

Synthetic form submission
  -> On form submission
  -> Add Intake Metadata
  -> Normalized JSON output

Result:

- Original form fields preserved: PASS
- Intake metadata added: PASS
- Data Types array preserved: PASS
- Workflow execution completed successfully: PASS

## Security Verification

- Synthetic test data only: PASS
- Real customer data used: NO
- Real employer data used: NO
- Credentials required by this workflow: NO
- Obvious secrets in exported workflow: NONE FOUND
- Synthetic execution data embedded in exported workflow: NONE FOUND
- Workflow is not published yet.

## Result

SaaS / AI security review intake workflow verification: PASS
