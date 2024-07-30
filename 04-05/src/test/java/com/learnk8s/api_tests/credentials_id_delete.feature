# ********RoostGPT********

# Test generated by RoostGPT for test karteKnoteTest using AI Type Open AI and AI Model gpt-4-1106-preview
# 
# Feature file generated for /credentials/{id}_delete for http method type DELETE 
# RoostTestHash=f1fc1d06f7
# 
# 

# ********RoostGPT********
Feature: Delete Credential from Wallet

  Background:
    * def urlBase = karate.properties['url.base'] || 'http://localhost:4010'
    * url urlBase
    * def authToken = karate.properties['AUTH_TOKEN']

  Scenario Outline: Delete a credential by ID with valid UUID
    Given path 'credentials', '<id>'
    And header ApiKeyAuth = authToken
    When method DELETE
    Then status 200
    And match header api-version == '1.0.0'

    Examples:
      | read('credentials_id_delete.csv') |

  Scenario Outline: Delete a credential by ID with invalid UUID should result in Bad Request
    Given path 'credentials', '<id>'
    And header ApiKeyAuth = authToken
    When method DELETE
    Then status 400
    And match header api-version == '1.0.0'
    And match response == """{ error: '#string', description: 'Descriptive Error Message' }"""

    Examples:
      | id    |
      | 12345 |

  Scenario Outline: Delete a credential without authentication should result in Authentication Required
    Given path 'credentials', '<id>'
    When method DELETE
    Then status 401
    And match header api-version == '1.0.0'
    And match response == """{ error: '#string', description: 'Descriptive Error Message' }"""

    Examples:
      | id                                   |
      | 123e4567-e89b-12d3-a456-426614174000 |
