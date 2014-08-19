Feature: Change Item Quantities

  As a shopper
  I want to change item quantities
  So I can purchase different amounts of the items in my cart

  Scenario: Increase the quantities
    Given I am visiting the cart
    And there is "1" "item" in my cart
    When I try to change the quantity of "item" to "2"
    Then "2" "items" should be in my cart

  Scenario: Decrease the quantities
    Given I am visiting the cart
    And there is "2" "items" in my cart
    When I try to change the quantity of "item" to "1"
    Then "1" "item" should be in my cart

  Scenario: Changing quantity to 0
    Given I am visiting the cart
    And there is "1" "item" in my cart
    When I try to change the quantity of "item" to "0"
    Then "item" should not be in my cart

  Scenario: Changing quantity of 1 item doesn't affect other items
    Given I am visiting the cart
    And there is "1" "item" in my cart
    And there is "1" "thing" in my cart
    When I try to change the quantity of "item" to "2"
    Then "2" "items" should be in my cart
    And "1" "thing" should be in my cart
