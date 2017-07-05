Feature: It can load configuration from environment variables
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application from environment variables

  Scenario: Load configuration
    Given I have configured Weave with a handler
    And I have configured Weave's Environment loader to load environment variables with prefix "WEAVE_"
    And the following environment variables exist
    | key               | value                     |
    | database_host     | my-database-host.com      |
    | database_port     | 6666                      |
    When I run Weave's Environment loader
    Then my application should be configured
