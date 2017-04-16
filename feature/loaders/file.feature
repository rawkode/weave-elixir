Feature: It can load configuration from a configured directory
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application from files on disk

  Scenario: Load configuration
    Given I have configured weave to load configuration from "secrets"
    And I have provided the configuration handler
    And the directory exists
    And the following files exist there
    | file_name         | contents                  |
    | database_host     | my-database-host.com      |
    | database_password | my-super-secret-password  |
    When I run the Weave file loader
    Then my application should be configured
