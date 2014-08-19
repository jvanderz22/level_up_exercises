Feature: Estimated Delivery Time

  As a shopper
  I want to add my address information
  So I can get an estimate of when my shipment will arrive

  Scenario: Can add address info
    Given I am visiting the cart
    Then I should be able to enter a valid "postal code"
    And I should be able to enter a valid "country"
    And I should be able to enter a valid "address"
    And I should be able to enter a valid "city"
    And I should be able to enter a valid "state"

  Scenario: Estimate can be found from country and postal code
    Given I am visiting the cart
    And I enter a valid "postal code"
    And I enter a valid "country"
    When I ask for a delivery estimate
    Then I should get an estimated time

  Scenario: Estimate can be found from country, city, and state/province
    Given I am visiting the cart
    And I enter a valid "city"
    And I enter a valid "state"
    And I enter a valid "country"
    When I ask for a delivery estimate
    Then I should get an estimated time

  Scenario: Estimate can be found from country, city, and state with invalid zip
    Given I am visiting the cart
    And I enter a valid "city"
    And I enter a valid "state"
    And I enter a valid "country"
    And I enter an invalid "postal code"
    When I ask for a delivery estimate
    Then I should get an estimated time

  Scenario: Estimate can be found from country and postal code with invalid city and state
    Given I am visiting the cart
    And I enter a valid "country"
    And I enter a valid "postal code"
    And I enter an invalid "city"
    And I enter an invalid "state"
    When I ask for a delivery estimate
    Then I should get an estimated time

  #sad path
  Scenario: Estimate won't be found without a valid country
    Given I am visting the cart
    And I enter a valid "postal code"
    And I enter an invalid "country"
    When I ask for a delivery estimate
    Then I should see an"invalid country" error
    And I should not get an estimated time

  Scenario: Estimate won't be found if the zip can't be found and no city and state are given
    Given I am visiting the cart
    And I enter a invalid "postal code"
    And I enter a valid "country"
    When I ask for a delivery estimate
    Then I should see an "invalid postal code" error
    And I should not get an estimated time

  Scenario: Estimate won't be found if the city can't be found and no zip is given
    Given I am visiting the cart
    And I enter a valid "state"
    And I enter a valid "country"
    And I enter an invalid "city"
    When I ask for a delivery estimate
    Then I should see an "invalid city" error
    And I should not get an estimated time

  Scenario: Estimate won't be found if the state can't be found and no zip is given
    Given I am visiting the cart
    And I enter a valid "city"
    And I enter a valid "country"
    And I enter an invalid "state"
    When I ask for a delivery estimate
    Then I should see an "invalid state" error
    And I should not get an estimated time

  Scenario: Multiple errors will stack
    Given I am visiting the cart
    And I enter a valid "country"
    And I enter an invalid "city"
    And I enter an invalid "state"
    And I enter an invalid "postal code"
    When I ask for a delivery estimate
    Then I should see an "invalid city" error
    And I should see an "invalid state" error
    And I should see an "invalid postal code" error
    And I should not get an estimate time
