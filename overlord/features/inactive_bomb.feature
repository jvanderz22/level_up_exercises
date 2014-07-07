Feature: Inactive Bomb

  As a villain
  I want to activate a booted bomb
  So that it can explode

  Scenario: There is an inactive bomb interface
    Given the bomb is booted with activation code "1234"
    Then I should see "Activate bomb?"
    And the bomb should be "Inactive"
    And the page should have a "Activate" button

  Scenario: Can activate bomb with correct code
    Given the bomb is booted with activation code "1234"
    When I enter activation code "1234"
    And I attempt to activate the bomb
    Then the bomb should be "Active"

  Scenario: Can't activate bomb with wrong code
    Given the bomb is booted with activation code "1234"
    When I enter activation code "5678"
    And I attempt to activate the bomb
    Then the bomb should be "Inactive"


