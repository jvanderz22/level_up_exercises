Feature: Remove Item from cart

  As a shopper
  I want to remove an item from my shopping cart
  So that I won't purchase it when I checkout

  Scenario: Can remove an item from the cart
    Given I am visiting the cart
    And there is "1" "item" in my cart
    When I try to remove "item" from my cart
    Then "item" should not be in my cart

  Scenario: Can remove multiple copies of an item from the cart
    Given I am visiting the cart
    And there is "2" "items" in my cart
    When I try to remove "item" from my cart
    Then "item" should not be in my cart

  Scenario: Other items will stay in the cart when one is removed
    Given I am visiting the cart
    And there is "1" "item" in my cart
    And there is "1" "thing" in my cart
    When I try to remove "item" from my cart
    Then "item" should not be in my cart
    And "thing" should be in my cart

  Scenario: Can remove multiple items from the cart
    Given I am visiting the cart
    And there is "1" item in my cart
    And there is "1" thing in my cart
    When I try to remove "item" from my cart
    And I try to remove "thing" from my cart
    Then "item" should not be in my cart
    And "thing" should not be in my cart

