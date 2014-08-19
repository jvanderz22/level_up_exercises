Feature: Add to cart

  As a shopper
  I want to add items to my shopping cart
  So that I can purchase these items

  #Happy Path
  Scenario: Add item to cart from its page
    Given I am on the "item" page
    And there are no "items" in my cart
    When I begin to add an "item" to the cart
    And I click "accept"
    Then "item" should be in my cart

  Scenario: Add item to cart from a list of items
    Given I am seeing a list of items
    And there are no "items" in my cart
    When I begin to add an "item" to the cart
    And I click "accept"
    Then "item" should be in my cart

  Scenario: Add multiple items to the cart
    Given I am on an "item" page
    And there are no "items" in my cart
    When I begin to add an "item" to the cart
    And I change the quanity to "2"
    And I click "accept"
    Then "2" "items" should be in my cart

  #Sad path
  Scenario: Can cancel adding an item to the cart
    Given I am on an "item" page
    And there are no "items" in my cart
    When I begin to add an "item" to the cart
    And I click "cancel"
    Then "item" should not be in my cart

  #Bad path
  Scenario: Won't add seperate records for the same item
    Given I am on an "item" page
    And there is "1" "item" in my cart
    When I begin to add an "item" to the card
    And I click "accept"
    Then "1" "item" should be in my cart
    And I should see an error
