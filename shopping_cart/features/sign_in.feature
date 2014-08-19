Feature: Signing In

  As a shopper
  I want to sign in to an account
  To be able to save my shopping cart to access later

  Scenario: Sign in with items already in cart
    Given I am visiting the cart
    And I am not signed in
    And there is "1" "item" in the cart
    When I sign in with nothing in my account's cart
    Then "1" "item" should be in my cart

  Scenario: Add items to cart from previous session
    Given I am visiting the cart
    And I am not signed in
    And there is "1" "item" in the cart
    When I sign in with "1" "thing" in my account's cart
    Then "1" "item" should be in my cart
    And "1" "thing" should be in my cart

  Scenario: Overwrite old quantities with current session data for the same item
    Given I am visiting the cart
    And I am not signed in
    And there is "1" "item" in the cart
    When I sign in with "2" "items" in my account's cart
    Then "1" "item" should be in my cart

  Scenario: The account's cart saves after logging out
    Given I am visiting the cart
    And I am signed into account "example"
    And there is "1" "item" in the cart"
    When I sign out
    And leave the site
    And I visit cart
    And I sign in
    Then "1" "item" should be in my cart
    
