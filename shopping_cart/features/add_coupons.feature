Feature: Add coupons

  As a user
  I want to add a coupon to my order
  So that I can save money

  Scenario: Enter a valid and unexpired coupon code
    Given I am visiting the cart
    And I enter a valid and unexpired coupon code
    When I try to add the coupon
    Then the coupon should be added to the order

  Scenario: Enter multiple valid and unexpired coupons
    Given I am visiting the cart
    And I added a valid and unexpired coupon
    And I enter a valid and unexpired coupon coe
    When I try to add the coupon
    Then two couponss should be added to the order

  Scenario: Can't enter an invalid coupon code
    Given I am visiting the cart
    And I enter an invalid coupon code
    When I try to add the coupon
    Then I should see an "invalid coupon" error
    And the coupon should not be added to the order

  Scenario: Can't enter an expired coupon code
    Given I am visiting the cart
    And I enter a valid but expired coupon code
    When I try to add the coupon
    Then I should see an "expired coupon" error
    And the coupon should not be added to the order
