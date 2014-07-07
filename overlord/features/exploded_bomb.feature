Feature: Bomb is exploded

  As a bomb
  I want to be unable to be interacted with
  So that I cannot be used again

  #happy path
  Scenario: There is an exploded bomb interface
    Given the bomb is exploded
    Then the bomb should be "Exploded"
    And there should be nothing for a user to interact with
