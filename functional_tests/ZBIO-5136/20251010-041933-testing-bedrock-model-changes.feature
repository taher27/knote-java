Feature: Credit Card Payment Collection System API Testing
  As a QA Engineer
  I want to validate the credit card payment collection system APIs
  So that customers can view balances, make payments, and receive collection calls correctly

  Background:
    Given the API base URL is set from environment variable "BASE_URL"
    And the authorization token is set from environment variable "AUTH_TOKEN"
    And the content type is "application/json"
    And the system date is set correctly

  # ============================================================================
  # FUNCTIONAL TEST SCENARIOS
  # ============================================================================

  Scenario: TC-ZBIO-5136-001 - Validate Current Unpaid Card Balance Display
    Given a customer account with ID "CUST123" exists in the system
    And the customer has an active credit card with ID "CARD456"
    And the card has an unpaid balance of 1500.00 USD
    When I send a GET request to "/api/v1/customers/CUST123/cards/CARD456/balance"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD456",
        "customerId": "CUST123",
        "unpaidBalance": 1500.00,
        "currency": "USD",
        "lastUpdated": "${TIMESTAMP}"
      }
      """
    And the unpaid balance should match the database value for card "CARD456"

  Scenario: TC-ZBIO-5136-002 - Validate Zero Balance for New Credit Cards
    Given a customer account with ID "CUST789" exists in the system
    And a new credit card with ID "CARD101" has been issued to customer "CUST789"
    And no transactions have been made on card "CARD101"
    When I send a GET request to "/api/v1/customers/CUST789/cards/CARD101/balance"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD101",
        "customerId": "CUST789",
        "unpaidBalance": 0.00,
        "currency": "USD",
        "transactionCount": 0
      }
      """
    And the field "unpaidBalance" should be 0.00

  Scenario: TC-ZBIO-5136-003 - Verify Payment Due Date Display
    Given a customer account with ID "CUST456" exists in the system
    And the customer has an active credit card with ID "CARD789"
    And the card has an outstanding balance of 2500.00 USD
    And the billing cycle ends on "2024-01-15"
    And the grace period is 21 days
    When I send a GET request to "/api/v1/customers/CUST456/cards/CARD789/payment-info"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD789",
        "unpaidBalance": 2500.00,
        "billingCycleEndDate": "2024-01-15",
        "paymentDueDate": "2024-02-05",
        "gracePeriodDays": 21
      }
      """
    And the payment due date should be calculated as billing cycle end date plus grace period

  Scenario: TC-ZBIO-5136-004 - Verify Payment Due Date for Newly Issued Cards
    Given a customer account with ID "CUST111" exists in the system
    And a new credit card with ID "CARD222" was issued on "2024-01-01"
    And the billing cycle is 30 days
    And the grace period is 21 days
    When I send a GET request to "/api/v1/customers/CUST111/cards/CARD222/payment-info"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD222",
        "cardIssueDate": "2024-01-01",
        "firstBillingCycleEndDate": "2024-01-31",
        "paymentDueDate": "2024-02-21"
      }
      """
    And the payment due date should be 51 days from card issue date

  Scenario: TC-ZBIO-5136-005 - Verify System Identifies Past Due Payment Status
    Given a customer account with ID "CUST333" exists in the system
    And the customer has a credit card with ID "CARD444"
    And the card has an unpaid balance of 3000.00 USD
    And the payment due date is "2024-01-10"
    And the current system date is "2024-01-15"
    When I send a GET request to "/api/v1/customers/CUST333/cards/CARD444/status"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD444",
        "paymentStatus": "PAST_DUE",
        "unpaidBalance": 3000.00,
        "paymentDueDate": "2024-01-10",
        "daysPastDue": 5,
        "statusIndicator": "OVERDUE"
      }
      """
    And the field "paymentStatus" should be "PAST_DUE"
    And the field "daysPastDue" should be greater than 0

  Scenario: TC-ZBIO-5136-006 - Verify Automated Call Trigger for Past Due Payment
    Given a customer account with ID "CUST555" exists in the system
    And the customer has a valid phone number "+1234567890"
    And the customer has a credit card with ID "CARD666"
    And the card has an unpaid balance of 5000.00 USD
    And the payment due date is "2024-01-05"
    And the current system date is "2024-01-06"
    And the customer has not opted out of collection calls
    When I send a POST request to "/api/v1/collections/trigger-automated-calls"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "callsTriggered": [
          {
            "customerId": "CUST555",
            "cardId": "CARD666",
            "phoneNumber": "+1234567890",
            "callScheduled": true,
            "callId": "${CALL_ID}",
            "scheduledTime": "${TIMESTAMP}"
          }
        ]
      }
      """
    When I send a GET request to "/api/v1/collections/calls?customerId=CUST555"
    Then the response status should be 200
    And the response should contain a call record with status "QUEUED" or "INITIATED"

  Scenario: TC-ZBIO-5136-007 - Verify No Call Trigger for New Cards Without Due Payment
    Given a customer account with ID "CUST777" exists in the system
    And the customer has a newly issued credit card with ID "CARD888"
    And the card has zero balance
    And no payment is due
    When I send a POST request to "/api/v1/collections/trigger-automated-calls"
    Then the response status should be 200
    And the response should not contain card "CARD888" in triggered calls list
    When I send a GET request to "/api/v1/collections/calls?customerId=CUST777&cardId=CARD888"
    Then the response status should be 200
    And the response should contain an empty calls array

  Scenario: TC-ZBIO-5136-008 - Verify Successful Payment Collection via Card Payment
    Given a customer account with ID "CUST999" exists in the system
    And the customer has a credit card with ID "CARD1010" with balance 1000.00 USD
    And valid test payment card details are available
    When I send a POST request to "/api/v1/payments/process" with body:
      """
      {
        "customerId": "CUST999",
        "cardId": "CARD1010",
        "paymentAmount": 500.00,
        "paymentMethod": {
          "type": "CREDIT_CARD",
          "cardNumber": "4111111111111111",
          "expiryMonth": "12",
          "expiryYear": "2025",
          "cvv": "123",
          "cardholderName": "John Doe"
        }
      }
      """
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "transactionId": "${TRANSACTION_ID}",
        "status": "SUCCESS",
        "paymentAmount": 500.00,
        "previousBalance": 1000.00,
        "newBalance": 500.00,
        "transactionDate": "${TIMESTAMP}",
        "receiptUrl": "${RECEIPT_URL}"
      }
      """
    When I send a GET request to "/api/v1/customers/CUST999/cards/CARD1010/balance"
    Then the response status should be 200
    And the field "unpaidBalance" should be 500.00

  Scenario: TC-ZBIO-5136-009 - Verify Payment Rejection for Invalid Card Details
    Given a customer account with ID "CUST1111" exists in the system
    And the customer has a credit card with ID "CARD1212" with balance 1000.00 USD
    When I send a POST request to "/api/v1/payments/process" with body:
      """
      {
        "customerId": "CUST1111",
        "cardId": "CARD1212",
        "paymentAmount": 500.00,
        "paymentMethod": {
          "type": "CREDIT_CARD",
          "cardNumber": "4111111111111112",
          "expiryMonth": "12",
          "expiryYear": "2020",
          "cvv": "999",
          "cardholderName": "Invalid Card"
        }
      }
      """
    Then the response status should be 400
    And the response should contain JSON:
      """
      {
        "status": "FAILED",
        "errorCode": "INVALID_CARD",
        "errorMessage": "Invalid card details or card expired",
        "paymentProcessed": false
      }
      """
    When I send a GET request to "/api/v1/customers/CUST1111/cards/CARD1212/balance"
    Then the response status should be 200
    And the field "unpaidBalance" should be 1000.00

  Scenario: TC-ZBIO-5136-010 - Verify Balance Update After Partial Payment
    Given a customer account with ID "CUST1313" exists in the system
    And the customer has a credit card with ID "CARD1414" with balance 500.00 USD
    When I send a POST request to "/api/v1/payments/process" with body:
      """
      {
        "customerId": "CUST1313",
        "cardId": "CARD1414",
        "paymentAmount": 200.00,
        "paymentMethod": {
          "type": "CREDIT_CARD",
          "cardNumber": "4111111111111111",
          "expiryMonth": "12",
          "expiryYear": "2025",
          "cvv": "123",
          "cardholderName": "Jane Doe"
        }
      }
      """
    Then the response status should be 200
    And the field "status" should be "SUCCESS"
    And the field "previousBalance" should be 500.00
    And the field "newBalance" should be 300.00
    When I send a GET request to "/api/v1/customers/CUST1313/cards/CARD1414/balance"
    Then the response status should be 200
    And the field "unpaidBalance" should be 300.00
    When I send a GET request to "/api/v1/customers/CUST1313/cards/CARD1414/transactions"
    Then the response status should be 200
    And the response should contain a payment transaction of 200.00 USD

  Scenario: TC-ZBIO-5136-011 - Verify Balance Update After Full Payment
    Given a customer account with ID "CUST1515" exists in the system
    And the customer has a credit card with ID "CARD1616" with balance 750.00 USD
    When I send a POST request to "/api/v1/payments/process" with body:
      """
      {
        "customerId": "CUST1515",
        "cardId": "CARD1616",
        "paymentAmount": 750.00,
        "paymentMethod": {
          "type": "CREDIT_CARD",
          "cardNumber": "4111111111111111",
          "expiryMonth": "12",
          "expiryYear": "2025",
          "cvv": "123",
          "cardholderName": "Full Payment User"
        }
      }
      """
    Then the response status should be 200
    And the field "status" should be "SUCCESS"
    And the field "newBalance" should be 0.00
    When I send a GET request to "/api/v1/customers/CUST1515/cards/CARD1616/status"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD1616",
        "unpaidBalance": 0.00,
        "accountStatus": "CURRENT",
        "paymentStatus": "PAID_IN_FULL"
      }
      """

  Scenario: TC-ZBIO-5136-012 - Verify Overpayment Handling
    Given a customer account with ID "CUST1717" exists in the system
    And the customer has a credit card with ID "CARD1818" with balance 100.00 USD
    When I send a POST request to "/api/v1/payments/process" with body:
      """
      {
        "customerId": "CUST1717",
        "cardId": "CARD1818",
        "paymentAmount": 150.00,
        "paymentMethod": {
          "type": "CREDIT_CARD",
          "cardNumber": "4111111111111111",
          "expiryMonth": "12",
          "expiryYear": "2025",
          "cvv": "123",
          "cardholderName": "Overpay User"
        }
      }
      """
    Then the response status should be 200
    And the field "status" should be "SUCCESS"
    And the field "previousBalance" should be 100.00
    And the field "newBalance" should be 0.00
    And the field "accountCredit" should be 50.00
    When I send a GET request to "/api/v1/customers/CUST1717/cards/CARD1818/balance"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "cardId": "CARD1818",
        "unpaidBalance": 0.00,
        "accountCredit": 50.00,
        "totalBalance": -50.00
      }
      """

  Scenario: TC-ZBIO-5136-013 - Verify Call Arrangement Workflow Initiation
    Given I am logged in as a customer service representative with ID "CSR001"
    And a customer account with ID "CUST1919" has a past due balance
    And the customer has valid contact information
    When I send a POST request to "/api/v1/collections/arrange-call" with body:
      """
      {
        "customerId": "CUST1919",
        "cardId": "CARD2020",
        "scheduledDateTime": "2024-02-01T14:00:00Z",
        "callType": "AUTOMATED",
        "reason": "Past due payment follow-up",
        "notes": "Customer prefers afternoon calls",
        "assignedTo": "CSR001"
      }
      """
    Then the response status should be 201
    And the response should contain JSON:
      """
      {
        "callId": "${CALL_ID}",
        "customerId": "CUST1919",
        "scheduledDateTime": "2024-02-01T14:00:00Z",
        "callType": "AUTOMATED",
        "status": "SCHEDULED",
        "createdBy": "CSR001",
        "createdAt": "${TIMESTAMP}"
      }
      """
    When I send a GET request to "/api/v1/customers/CUST1919/activity-log"
    Then the response status should be 200
    And the response should contain an activity entry with type "COLLECTION_CALL_SCHEDULED"

  Scenario: TC-ZBIO-5136-014 - Verify Payment Collection Process Integration
    Given a customer account with ID "CUST2121" exists with past due balance
    And a collection call with ID "CALL001" has been completed
    When I send a POST request to "/api/v1/collections/calls/CALL001/disposition" with body:
      """
      {
        "callId": "CALL001",
        "disposition": "PAYMENT_COMMITTED",
        "notes": "Customer agreed to pay $500 by 2024-02-05",
        "paymentCommitment": {
          "amount": 500.00,
          "commitmentDate": "2024-02-05"
        },
        "followUpRequired": true,
        "followUpDate": "2024-02-06"
      }
      """
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "callId": "CALL001",
        "dispositionRecorded": true,
        "followUpTaskId": "${TASK_ID}",
        "paymentCommitmentTracked": true
      }
      """
    When I send a GET request to "/api/v1/customers/CUST2121/payment-commitments"
    Then the response status should be 200
    And the response should contain a commitment for 500.00 USD due on "2024-02-05"
    When I send a GET request to "/api/v1/tasks?customerId=CUST2121&type=FOLLOW_UP"
    Then the response status should be 200
    And the response should contain a follow-up task scheduled for "2024-02-06"

  Scenario: TC-ZBIO-5136-015 - Verify Multiple Payment Attempts Handling
    Given a customer account with ID "CUST2323" exists in the system
    And the customer has a credit card with ID "CARD2424" with balance 1000.00 USD
    When I send a POST request to "/api/v1/payments/process" with invalid card details
    Then the response status should be 400
    And the field "status" should be "FAILED"
    When I send a POST request to "/api/v1/payments/process" with different invalid card details
    Then the response status should be 400
    And the field "status" should be "FAILED"
    When I send a POST request to "/api/v1/payments/process" with body:
      """
      {
        "customerId": "CUST2323",
        "cardId": "CARD2424",
        "paymentAmount": 300.00,
        "paymentMethod": {
          "type": "CREDIT_CARD",
          "cardNumber": "4111111111111111",
          "expiryMonth": "12",
          "expiryYear": "2025",
          "cvv": "123",
          "cardholderName": "Valid User"
        }
      }
      """
    Then the response status should be 200
    And the field "status" should be "SUCCESS"
    And the field "newBalance" should be 700.00
    When I send a GET request to "/api/v1/customers/CUST2323/cards/CARD2424/transactions?type=PAYMENT_ATTEMPT"
    Then the response status should be 200
    And the response should contain 3 payment attempts
    And the response should contain 2 failed attempts
    And the response should contain 1 successful attempt
    And all attempts should have unique transaction IDs and timestamps

  # ============================================================================
  # NON-FUNCTIONAL TEST SCENARIOS
  # ============================================================================

  Scenario: TC-ZBIO-5136-NF-001 - Verify System Response Time for Balance Retrieval
    Given a customer account with ID "CUST_PERF_001" exists with active credit card
    And performance monitoring is enabled
    When I measure the response time for GET request to "/api/v1/customers/CUST_PERF_001/cards/CARD_PERF_001/balance"
    Then the response status should be 200
    And the response time should be less than 2000 milliseconds
    And the response should contain valid balance information
    When I send 20 consecutive GET requests to "/api/v1/customers/CUST_PERF_001/cards/CARD_PERF_001/balance"
    Then the average response time should be less than 2000 milliseconds
    And the 95th percentile response time should be less than 3000 milliseconds
    And no timeout errors should occur

  Scenario: TC-ZBIO-5136-NF-002 - Verify Concurrent User Load Handling for Balance Checks
    Given 500 customer accounts exist with active credit cards
    And load testing is configured for concurrent users
    When I simulate 50 concurrent users checking their card balance
    Then all requests should complete successfully
    And the success rate should be at least 99 percent
    And the average response time should be less than 2500 milliseconds
    When I simulate 100 concurrent users checking their card balance
    Then the success rate should be at least 99 percent
    And the average response time should increase by no more than 50 percent
    When I simulate 500 concurrent users checking their card balance
    Then the success rate should be at least 99 percent
    And the error rate should be less than 1 percent
    And no system crashes or service outages should occur

  Scenario: TC-ZBIO-5136-NF-003 - Verify Automated Call System Reliability
    Given the automated call system is operational
    And 50 test accounts with past due balances exist
    And system monitoring is enabled for 24 hours
    When I send a POST request to "/api/v1/collections/trigger-automated-calls" every hour for 24 hours
    Then the automated call system should maintain 99.5 percent uptime
    And the call success rate should be at least 95 percent
    When I send a GET request to "/api/v1/collections/system-health"
    Then the response status should be 200
    And the response should contain JSON:
      """
      {
        "uptime": ">99.5%",
        "callSuccessRate": ">95%",
        "systemStatus": "HEALTHY",
        "memoryUsage": "STABLE",
        "queueBacklog": 0
      }
      """
    And no unhandled exceptions should be logged
    And system resources should remain stable

  Scenario: TC-ZBIO-5136-NF-004 - Verify Payment Transaction Security and Encryption
    Given security testing tools are configured
    When I send a POST request to "/api/v1/payments/process" with payment details
    Then the connection should use HTTPS protocol
    And the TLS version should be 1.2 or higher
    And the encryption algorithm should be AES-256 or equivalent
    When I inspect the request payload
    Then card details should be encrypted during transmission
    And sensitive data should be tokenized
    When I send a GET request to "/api/v1/customers/CUST_SEC_001/cards/CARD_SEC_001/transactions"
    Then the response status should be 200
    And card numbers should be masked showing only last 4 digits
    And CVV should never be displayed or stored
    When I attempt SQL injection on payment endpoints
    Then the response status should be 400 or 403
    And no database errors should be exposed
    When I check session management
    Then session tokens should expire after inactivity
    And authentication should be required for all payment operations

  Scenario: TC-ZBIO-5136-NF-005 - Verify Disaster Recovery Time Objective
    Given the payment collection system is operational
    And disaster recovery procedures are documented
    And backup systems are configured
    When I simulate a critical system failure in test environment
    And I initiate disaster recovery procedures
    And I measure the time to restore full functionality
    Then the system should recover within 4 hours
    When I send a GET request to "/api/v1/system/health" after recovery
    Then the response status should be 200
    And all critical services should be operational
    When I verify data integrity post-recovery
    Then no committed transactions should be lost
    And in-progress transactions should be properly handled
    When I test payment collection functions post-recovery
    Then all payment operations should work correctly
    And automated call system should resume operation
    And balance retrieval should function normally

  Scenario: TC-ZBIO-5136-NF-006 - Verify System Scalability for Growing User Base
    Given baseline performance is established with 1000 users
    And scalability testing environment is configured
    When I simulate 2000 concurrent users (2x baseline load)
    Then the system should maintain acceptable performance
    And response times should remain within 50 percent of baseline
    When I add additional system resources (horizontal scaling)
    And I simulate 5000 concurrent users (5x baseline load)
    Then the system should maintain acceptable performance
    And the success rate should be at least 99 percent
    When I simulate 10000 concurrent users (10x baseline load)
    And I verify auto-scaling capabilities
    Then the system should scale automatically if cloud-based
    And response times should remain within acceptable limits
    And no single point of failure should exist
    When I send a GET request to "/api/v1/system/metrics"
    Then the response should show successful scaling
    And database should handle increased transaction volume
    And cost of scaling should be proportional to load increase

  Scenario: TC-ZBIO-5136-NF-007 - Verify Audit Trail and Compliance Logging
    Given audit logging is enabled in the system
    And a customer account with ID "CUST_AUDIT_001" exists
    When I send a GET request to "/api/v1/customers/CUST_AUDIT_001/cards/CARD_AUDIT_001/balance"
    Then the response status should be 200
    And the activity should be logged in the audit trail
    When I send a POST request to "/api/v1/payments/process" with payment details
    Then the payment attempt should be logged with timestamp
    And user identity should be recorded
    And IP address should be captured
    When I send a GET request to "/api/v1/audit-logs?customerId=CUST_AUDIT_001"
    Then the response status should be 200
    And the response should contain all activities with timestamps
    And sensitive data should be properly masked in logs
    And full card numbers should never appear in logs
    When I verify log retention policy
    Then logs should be retained for at least 7 years
    And logs should be immutable and tamper-proof
    When I attempt to modify an audit log entry
    Then the modification should be rejected
    And the attempt should be logged as a security event
    When I generate a compliance report
    Then all payment activities should be included
    And the report should meet PCI-DSS requirements
    And the report should be exportable in standard formats

  Scenario: TC-ZBIO-5136-NF-008 - Verify Accessibility Compliance for Payment Interfaces
    Given accessibility testing tools are configured
    When I scan the payment API documentation page with automated tools
    Then WCAG 2.1 Level AA violations should be zero or minimal
    When I test keyboard navigation on payment web interface
    Then all interactive elements should be keyboard accessible
    And tab order should be logical and sequential
    When I test with screen reader software
    Then all form fields should have proper labels
    And error messages should be clearly announced
    And payment status should be announced correctly
    When I verify color contrast ratios
    Then text should have minimum 4.5:1 contrast ratio
    And large text should have minimum 3:1 contrast ratio
    When I test browser zoom at 200 percent
    Then layout should remain usable
    And no functionality should be lost
    When I verify form error handling
    Then error messages should be clear and descriptive
    And errors should not depend solely on color
    When I test time-limited payment sessions
    Then adequate time should be provided for payment completion
    And warnings should be given before session expiration
    And users should have option to extend time if needed
