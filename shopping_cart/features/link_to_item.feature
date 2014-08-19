Feature: Link to item page from the cart

  As a shopper
  I want to get to an item's page from the cart
  So I can decide if I want to purchase it

  Scenario: Click to Item Page
    Given I am visiting the cart
    And there is "1" "item" in the cart
    When I click on the "item" name
    Then I should be redirected to the "item" page
