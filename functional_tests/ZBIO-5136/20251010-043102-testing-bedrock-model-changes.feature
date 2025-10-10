Feature: Credit Card Balance and Payment Management

  Background:
    Given the API base URL '${BASE_URL}'
    And the authorization header is set with bearer token '${AUTH_TOKEN}'
    And the content type is 'application/json'

  Scenario: TC-001 Validate Current Unpaid Credit Card Balance
    Given a user with an active credit card account
    And the user is authenticated in the system
    And the credit card has transaction history
    When I send a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then the response status should be 200
    And the response should contain the unpaid balance amount
    And the balance should match the calculated value from the database
    And the balance should reflect all posted transactions, payments, and charges

  Scenario: TC-002 Verify Payment Due Date Accuracy
    Given a user with an active credit card account
    And the user is authenticated in the system
    And the credit card has an outstanding balance
    When I send a GET request to "/accounts/credit-cards/{cardId}/payment-due"
    Then the response status should be 200
    And the response should contain the payment due date
    And the payment due date should match the calculated date based on billing cycle rules

  Scenario: TC-003 Past Due Payment Automated Call Trigger
    Given a credit card account with an unpaid balance
    And the payment due date has passed
    When I send a POST request to "/system/batch/trigger-collection-calls" with payload:
      """
      {
        "runDate": "2023-11-15",
        "accountTypes": ["credit-card"],
        "pastDueDays": 1
      }
      """
    Then the response status should be 200
    And the system should generate an outbound call record in the collection system
    When I send a GET request to "/system/outbound-calls/queue"
    Then the response should contain the account in the call queue
    And the call should contain the appropriate payment reminder message

  Scenario: TC-004 Card Payment Collection Process
    Given a credit card account with an unpaid balance
    When I send a POST request to "/accounts/credit-cards/{cardId}/payments" with payload:
      """
      {
        "amount": 500.00,
        "paymentMethod": "card",
        "cardDetails": {
          "cardNumber": "4111111111111111",
          "expiryDate": "12/2025",
          "cvv": "123"
        }
      }
      """
    Then the response status should be 201
    And the response should contain a payment confirmation reference
    When I send a GET request to "/accounts/credit-cards/{cardId}/transactions"
    Then the response should include the payment transaction
    And the transaction should show status "completed"
    When I send a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then the balance should be reduced by the payment amount

  Scenario: TC-005 Balance Update After Payment
    Given a credit card account with initial balance of 1000.00
    When I send a POST request to "/accounts/credit-cards/{cardId}/payments" with payload:
      """
      {
        "amount": 200.00,
        "paymentMethod": "bank",
        "bankDetails": {
          "accountNumber": "12345678",
          "routingNumber": "087654321"
        }
      }
      """
    Then the response status should be 201
    When I send a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then the response status should be 200
    And the balance should equal 800.00

  Scenario: TC-006 Handle Overpayment Scenario
    Given a credit card account with initial balance of 500.00
    When I send a POST request to "/accounts/credit-cards/{cardId}/payments" with payload:
      """
      {
        "amount": 600.00,
        "paymentMethod": "bank",
        "bankDetails": {
          "accountNumber": "12345678",
          "routingNumber": "087654321"
        }
      }
      """
    Then the response status should be 201
    When I send a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then the response status should be 200
    And the balance should equal -100.00
    And the response should indicate a credit balance status

  Scenario: TC-007 Invalid Payment Card Rejection
    Given a credit card account with an unpaid balance
    When I send a POST request to "/accounts/credit-cards/{cardId}/payments" with payload:
      """
      {
        "amount": 300.00,
        "paymentMethod": "card",
        "cardDetails": {
          "cardNumber": "1234567890123456",
          "expiryDate": "01/2020",
          "cvv": "999"
        }
      }
      """
    Then the response status should be 400
    And the response should contain error message about invalid card details
    When I send a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then the balance should remain unchanged

  Scenario: TC-008 New Card Zero Balance Verification
    Given a newly issued credit card
    When I send a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then the response status should be 200
    And the balance should equal 0.00
    When I send a GET request to "/accounts/credit-cards/{cardId}/transactions"
    Then the response should show an empty transaction list

  Scenario: TC-009 Card Balance Retrieval Response Time
    Given the system is prepared for performance testing
    When I send 100 concurrent GET requests to "/accounts/credit-cards/{cardId}/balance"
    Then all responses should return within 2000 milliseconds
    And 95% of responses should return within 1000 milliseconds
    And all responses should have status code 200
    And the response times should be consistent regardless of account history size

  Scenario: TC-010 Concurrent User Load Test for Balance Checking
    Given the system is prepared for load testing
    When I gradually increase concurrent users from 100 to 10000 over 30 minutes
    And each user sends a GET request to "/accounts/credit-cards/{cardId}/balance"
    Then all responses should have status code 200
    And 99% of responses should return within 3000 milliseconds
    And the system CPU usage should remain below 80%
    And the system memory usage should remain below 90%

  Scenario: TC-011 Automated Call System Reliability Test
    Given 500 test accounts with past due payments between 1 and 90 days
    When I send a POST request to "/system/batch/trigger-collection-calls" with payload:
      """
      {
        "runDate": "2023-11-15",
        "accountTypes": ["credit-card"],
        "pastDueDays": [1, 30, 60, 90]
      }
      """
    And the system runs continuously for 72 hours
    Then at least 98% of calls should be completed successfully
    And all call recordings should contain clear and accurate messages
    And the system should operate without failures for the entire test period

  Scenario: TC-012 Payment Collection Security Assessment
    Given the payment collection API endpoint is available
    When I attempt SQL injection attacks on the payment form fields
    Then the response status should be 400
    And the response should contain security violation messages
    When I monitor the network traffic during a payment request
    Then all data should be transmitted using TLS 1.2 or higher
    And credit card numbers should be masked in logs and UI
    When I attempt to access payment details through unauthorized endpoints
    Then the response status should be 401 or 403

  Scenario: TC-013 Disaster Recovery for Payment Collection System
    Given multiple payment transactions are in progress
    When the system experiences a simulated database failure
    And disaster recovery procedures are initiated
    Then the system should be fully restored within the defined RTO of 30 minutes
    And completed transactions before the failure should be preserved
    And in-progress transactions should have clear status indicators
    When I send a POST request to "/accounts/credit-cards/{cardId}/payments" after recovery
    Then the system should process the payment normally
    And data integrity should be maintained
