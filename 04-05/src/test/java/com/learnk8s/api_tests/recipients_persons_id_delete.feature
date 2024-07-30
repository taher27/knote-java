# ********RoostGPT********

# Test generated by RoostGPT for test karteKnoteTest using AI Type Open AI and AI Model gpt-4-1106-preview
# 
# Feature file generated for /recipients/persons/{id}_delete for http method type DELETE 
# RoostTestHash=819791060f
# 
# 

# ********RoostGPT********
Feature: Recipient Person API endpoint tests

  Background:
    * def urlBase = karate.properties['url.base'] || karate.get('urlBase', 'http://localhost:4010')
    * url urlBase
    * def authToken = karate.properties['AUTH_TOKEN']
    * header ApiKeyAuth = authToken

  Scenario Outline: Get recipient person by valid UUID
    Given path 'recipients/persons', '<id>'
    When method get
    Then status 200
    And match responseHeaders['api-version'] == '1.0.0'
    And match each response == { id: '#uuid', name: '#string', email: '#string' }

    Examples:
      | read('recipients_persons_id_delete.csv') |

  Scenario: Get recipient person by invalid UUID results in Bad Request
    Given path 'recipients/persons', 'invalid-uuid'
    When method get
    Then status 400
    And match responseHeaders['api-version'] == '1.0.0'
    And match response == { error: '#regex(^error/.+$)', description: 'Descriptive Error Message' }

  Scenario: Get recipient person without authorization results in Authentication Required
    Given path 'recipients/persons', '123e4567-e89b-12d3-a456-426614174000'
    And header ApiKeyAuth = ''
    When method get
    Then status 401
    And match responseHeaders['api-version'] == '1.0.0'
    And match response == { error: '#regex(^validation/.+$)', description: 'Descriptive Error Message' }
