Feature: Villain Boots Bomb

  As a villain
  I want to open the website
  So that I can boot the bomb

  #happy paths
  Scenario: Load Home Page
    Given the bomb is not booted
    Then I should see "Boot bomb?"
    And the bomb should be "Not Booted"
    And the page should have a "Boot" button

  Scenario: Boot with no codes
    Given the bomb is not booted
    When I don't enter an activation code
    And I don't enter a deactivation code
    And I attempt to boot the bomb
    Then the bomb should be "Inactive"

  Scenario: Boot with 4 digit activation code
    Given the bomb is not booted
    And an entered valid deactivation code
    When I enter a 4 digit activation code
    And I attempt to boot the bomb
    Then the bomb should be "Inactive"

  Scenario: Boot with 4 digit deactivation code
    Given the bomb is not booted
    And an entered valid activation code
    When I enter a 4 digit deactivation code
    And I attempt to boot the bomb
    Then the bomb should be "Inactive"

  #sad paths
  Scenario Outline: Fail to boot with an invalid activation code
    Given the bomb is not booted
    And an entered valid deactivation code
    When I enter "<invalid_code>" as an activation code
    And I attempt to boot the bomb
    Then the bomb should be "Not Booted"

    Examples:
      | invalid_code  |
      | 12345         |
      | 123           |
      | abcd          |
      | 12.2          |
      | 123a          |

 Scenario Outline: Fail to boot with an invalid deactivation code
    Given the bomb is not booted
    And an entered valid activation code
    When I enter "<invalid_code>" as a deactivation code
    And I attempt to boot the bomb
    Then the bomb should be "Not Booted"

    Examples:
      | invalid_code  |
      | 12345         |
      | 123           |
      | abcd          |
      | 12.2          |
      | 123a          |


