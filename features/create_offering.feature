Feature: Create an Offering
  As a user
  I want to create an offering
  So that other users can request to meet me

  Scenario: Successfully create an offering
    Given I am logged in
    When I visit the new offering page
    And I fill in the offering details
    And I submit the form
    Then I should see my offering on my profile