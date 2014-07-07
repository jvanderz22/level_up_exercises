Feature: Activated Bomb

  As a villain
  I want to deactivate a bomb
  So that it can no longer explode

  #happy path
  Scenario: There is an active bomb interface
    Given the bomb is booted with deactivation code "0000"
    And the bomb is activated
    Then I should see "Deactivate bomb?"
    And the bomb should be "Active"
    And the page should have a "Deactivate" button
    And the page should have the number of failed deactivation attempts

  Scenario: Can deactivate with the correct code
    Given the bomb is booted with deactivation code "0000"
    And the bomb is activated
    When I enter deactivation code "0000"
    And I attempt to deactivate the bomb
    Then the bomb should be "Inactive"

  Scenario: Will explode with the wrong code entered 3 times
    Given the bomb is booted with deactivation code "0000"
    And the bomb is activated
    When I enter deactivation code "1111"
    And I attempt to deactivate the bomb
    And I enter deactivation code "1111"
    And I attempt to deactivate the bomb
    And I enter deactivation code "1111"
    And I attempt to deactivate the bomb
    Then the bomb should be "Exploded"

  #sad path
  Scenario: Won't deactivate with the wrong code
    Given the bomb is booted with deactivation code "0000"
    And the bomb is activated
    When I enter deactivation code "1111"
    And I attempt to deactivate the bomb
    Then the bomb should be "Active"
    And the page should say there is "1" failed deactivation attempt

