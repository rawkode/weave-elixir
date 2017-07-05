Feature: It can be configured to load configuration using multiple loaders
  In order to configure my application from different sources
  As a Developer
  I need to be able to configure my application with multiple loaders

  Scenario: Load configuration
    Given I have configured Weave with a handler
    And I have configured Weave to use multiple loaders

    And I have configured Weave's Environment loader to load environment variables with prefix "WEAVE_"
    And the following environment variables exist
    | key               | value                     |
    | database_host     | my-database-host.com      |

    And I have configured Weave's File loader to load configuration from "secrets"
    And the directory exists
    And the following files exist there
    | file_name         | contents                  |
    | cookie_secret     | I am super Secur3         |

    When I run Weave.configure
    Then my application should be configured by both loaders
