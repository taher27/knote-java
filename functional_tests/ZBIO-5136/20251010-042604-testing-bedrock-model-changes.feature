Feature: Credit Card Payment Collection System

Background:
  Given the API base URL is set to the payment collection system
  And the authorization header is set for system access
  And the content type is 'application/json'

Scenario: Verify Unpaid Credit Card Balance
  Given a credit card account with ID "CC001" has an unpaid balance
  And the payment due date has passed
  When I send a GET request to "/api/credit-cards/CC001/balance"
  Then the response status should be 200
  And the response should contain the correct unpaid balance
  And the balance should match the amount not paid by the due date

Scenario: Automated Call Trigger for Overdue Payment
  Given a credit card account with ID "CC002" has an unpaid balance
  And the payment due date has just passed
  When the system processes overdue accounts
  And I send a GET request to "/api/automated-calls/CC002"
  Then the response status should be 200
  And the response should indicate an automated call was triggered
  And the call should be directed to the customer's registered phone number

Scenario: Card Payment Collection Process
  Given a credit card account with ID "CC003" has an overdue balance
  And valid payment details are available
  When I send a POST request to "/api/payments/CC003" with the payment details
  Then the response status should be 200
  And the response should contain a successful payment confirmation
  And the unpaid balance should be reduced by the payment amount
  When I send a GET request to "/api/credit-cards/CC003/balance"
  Then the response should show the updated balance

Scenario: Balance Update After Partial Payment
  Given a credit card account with ID "CC004" has an overdue balance of $1000
  When I send a POST request to "/api/payments/CC004" with a partial payment of $500
  Then the response status should be 200
  And the response should confirm the partial payment
  When I send a GET request to "/api/credit-cards/CC004/balance"
  Then the response should show a remaining balance of $500
  And the account status should be updated if the minimum payment was met

Scenario: Payment Processing Performance
  Given 100 simulated payment transactions for overdue credit card accounts
  When I send a POST request to "/api/bulk-payments" with the 100 transactions
  Then the response status should be 202
  And the system should process all payments within 5 minutes
  When I send a GET request to "/api/bulk-payments/status"
  Then the response should indicate all transactions were successful
  And all account balances should be correctly updated

Scenario: Data Security in Payment Collection
  Given a credit card account with ID "CC005" has an overdue balance
  When I send a POST request to "/api/payments/CC005" with payment details
  Then the response status should be 200
  And all transmitted data should be encrypted
  When I attempt to intercept the payment information
  Then the intercepted data should be unreadable
  When I send a GET request to "/api/payments/CC005/details"
  Then the response should not contain raw payment information
  And access to this endpoint should be logged
