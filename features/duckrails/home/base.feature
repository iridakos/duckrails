Feature: There is a home page with options to do stuff

Background:
  * I visit the home page
  * I should see a link with text 'View all mocks'
  * I should see a link with text 'Create new mock'
  * I should see a menu link with text 'All mocks'
  * I should see a menu link with text 'New mock'

Scenario: I can navigate to the mocks page via the link
  When I click on the link with text 'View all mocks'
  Then I should be on the mocks page

Scenario: I can navigate to the new mock page via the link
  When I click on the link with text 'Create new mock'
  Then I should be on the new mock page


Scenario: I can navigate to the mocks page via the menu
  When I click on the menu link with text 'All mocks'
  Then I should be on the mocks page

Scenario: I can navigate to the new mock page via the menu
  When I click on the menu link with text 'New mock'
  Then I should be on the new mock page
