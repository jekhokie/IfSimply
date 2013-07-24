Feature: Visitor Signs Up
  In order to subscribe to or create a Club
  As a visitor
  I want to be able to sign up to the site

  Scenario Outline: Sign Up to Site
    Given I am on the ifSimply home page
    When I click "Sign Up Now!"
    And I fill in "user_name" with "Test"
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password_confirmation>"
    And I press "Sign Up"
    Then I should see a successful sign up message

    Examples:
      | name   | email          | password      | password_confirmation    |
      | Steve  | steve@test.com | stevie1234    | stevie1234               |
      | Tom    | tom@test.com   | tommie1234    | tommie1234               |
