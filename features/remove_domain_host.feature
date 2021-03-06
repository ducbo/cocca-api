Feature: Remove Domain Host

  Background:
    Given I am authenticated as partner

  Scenario: Remove domain host
    When  I try to remove a domain host from a domain
    Then  domain must no longer have domain host

  Scenario: Remove domain host failed
    When  I try to remove a domain host from a domain and fails
    Then  error must be validation failed

  Scenario Outline: Invalid parameters
    When  I try to remove a domain host with <invalid parameter>
    Then  error must be validation failed

    Examples:
      | invalid parameter |
      | no domain         |
      | no name           |
