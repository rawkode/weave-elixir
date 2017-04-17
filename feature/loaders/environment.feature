Feature: It can load configuration from environment variables
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application from environment variables

  Scenario: Load configuration
    Given I have configured weave to load environment variables with prefix "WEAVE_"
    And I have provided the configuration handler
    And the following environment variables exist
    | key               | value                     |
    | database_host     | my-database-host.com      |
    | database_port     | 6666                      |
    When I run the Weave file loader
    Then my application should be configured
