# ********RoostGPT********

# Test generated by RoostGPT for test karteKnoteTest using AI Type Open AI and AI Model gpt-4-1106-preview
# 
# Feature file generated for /registrations/{id}_delete for http method type DELETE 
# RoostTestHash=2c75b43156
# 
# 

# ********RoostGPT********
Feature: Registrations Endpoint Feature

  Background:
    * def urlBase = karate.properties['url.base'] || karate.get('urlBase', 'http://localhost:4010')
    * url urlBase
    * def authToken = karate.properties['AUTH_TOKEN']
    * header ApiKeyAuth = authToken

  Scenario: Get a registration with a valid UUID
    Given path 'registrations', '123e4567-e89b-12d3-a456-426614174000'
    When method get
    Then status 200
    And match responseHeaders contains { 'api-version': '#string' }

  Scenario: Get a registration with an invalid UUID
    Given path 'registrations', 'invalid-uuid'
    When method get
    Then status 400
    And match responseHeaders contains { 'api-version': '#string' }
    And match response contains { error: '#string', description: '#string' }

  Scenario: Get a registration without authorization
    * header ApiKeyAuth = null
    Given path 'registrations', '123e4567-e89b-12d3-a456-426614174000'
    When method get
    Then status 401
    And match responseHeaders contains { 'api-version': '#string' }
    And match response contains { error: '#string', description: '#string' }
