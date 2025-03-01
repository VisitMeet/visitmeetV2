Feature: Manage tags on user profiles

  Scenario: Add a tag to a user profile
    Given a user exists with email "user@example.com" and password "password"
    And I am logged in as "user@example.com"
    When I visit the profile page of the user
    And I fill in "tag_name" with "newtag"
    And I press "Add Tag"
    Then I should see "#newtag" in the list of tags

  Scenario: Remove a tag from a user profile
    Given a user exists with email "user@example.com" and password "password"
    And the user has a tag "existingtag"
    And I am logged in as "user@example.com"
    When I visit the profile page of the user
    And I click the remove button for "existingtag"
    Then I should not see "#existingtag" in the list of tags
