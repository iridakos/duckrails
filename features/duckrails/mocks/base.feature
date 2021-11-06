Feature: There is a mocks page with options to do stuff

Background:
  * There are 3 active mocks
  * There are 3 inactive mocks
  * I visit the mocks page
  * I should see a link with text 'Create new mock'
  * I should not see a link with text 'View all mocks'
  * I should see a menu link with text 'All mocks'
  * I should see a menu link with text 'New mock'
  * There should be an entry for mock with id 0
  * There should be an entry for mock with id 1
  * There should be an entry for mock with id 2

Scenario: I can select to create a new mock
  When I click on the link with text 'Create new mock'
  Then I should be on the new mock page

Scenario: I can select to edit a mock
  When I click the edit link for mock with id 0
  Then I should be on the edit mock page with id 0
  When I click on the link with text 'Cancel'
  Then I should be on the mocks page
  When I click the edit link for mock with id 1
  Then I should be on the edit mock page with id 1
  When I click on the link with text 'Cancel'
  Then I should be on the mocks page
  When I click the edit link for mock with id 2
  Then I should be on the edit mock page with id 2
  When I click on the link with text 'Cancel'
  Then I should be on the mocks page

@javascript
Scenario: I can select to delete a mock
  When I click the delete link for mock with id 1 and I dismiss the dialog with text 'Are you sure you want to delete this mock?'
  Then I should be on the mocks page
  And There should be an entry for mock with id 1
  When I click the delete link for mock with id 1 and I confirm the dialog with text 'Are you sure you want to delete this mock?'
  Then I should be on the mocks page
  And There should not be an entry for mock with id 1

@javascript
Scenario: I can activate a mock
  When I click the activate link for mock with id 4 and I dismiss the dialog with text 'Are you sure you want to activate this mock?'
  Then I should be on the mocks page
  And There should be an entry for mock with id 4
  When I click the activate link for mock with id 4 and I confirm the dialog with text 'Are you sure you want to activate this mock?'
  Then I should be on the mocks page
  When I click the deactivate link for mock with id 4 and I dismiss the dialog with text 'Are you sure you want to deactivate this mock?'
  Then I should be on the mocks page

@javascript
Scenario: I can deactivate a mock
  When I click the deactivate link for mock with id 1 and I dismiss the dialog with text 'Are you sure you want to deactivate this mock?'
  Then I should be on the mocks page
  And There should be an entry for mock with id 1
  When I click the deactivate link for mock with id 1 and I confirm the dialog with text 'Are you sure you want to deactivate this mock?'
  Then I should be on the mocks page
  When I click the activate link for mock with id 1 and I dismiss the dialog with text 'Are you sure you want to activate this mock?'
  Then I should be on the mocks page
