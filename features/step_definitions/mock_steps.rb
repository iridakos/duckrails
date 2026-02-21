Given /^There are (\d*)(?: )?(active|inactive)? mocks$/ do |number, active_status|
  active = active_status != 'inactive'
  count = Duckrails::Mock.count
  number.to_i.times do |i|
    index = i + count
    FactoryBot.create :mock, route_path: "/cucumber/#{index}", name: "Mock:#{index}", id: index, active: active
  end
end

When /^I click the edit link for mock with id (\d*)$/ do |mock_id|
  page.find("table.mocks tbody tr[data-mock-id='#{mock_id}']").find('a.edit').click
end

When /^I click the (delete|activate|deactivate) link for mock with id (\d*) and I (confirm|dismiss) the dialog with text '([^\']*)'$/ do |link_action, mock_id, dialog_action, dialog_text|
  action = dialog_action == 'confirm' ? :accept_confirm : :dismiss_confirm
  page.send action, text: dialog_text do
    page.find("table.mocks tbody tr[data-mock-id='#{mock_id}']").find("a.#{link_action}").click
  end
end

Then /^There should( not)? be an entry for mock with id (\d*)$/ do |should_not, mock_id|
  should_mode = should_not ? :not_to : :to
  expect(page).send should_mode, have_css("table.mocks tbody tr[data-mock-id='#{mock_id}']")
end

Then /^The mock form should( not)? have errors$/ do |should_not|
  should_mode = should_not ? :not_to : :to
  expect(page).send(should_mode, have_css('form.mock-form .invalid-feedback'))
end

When /^I submit the mock form$/ do
  page.find('form.mock-form input[type="submit"]').click
end

Then /^The (General|Response body|Headers|Advanced) tab of the mock form should( not)? have errors$/ do |tab, should_not|
  should_mode = should_not ? :not_to : :to
  expect(page).send should_mode, have_css('form.mock-form ul.nav-tabs li a.error', text: tab)
end

And /^The (General|Response body|Headers|Advanced) tab of the mock form should be selected$/ do |tab|
  expect(page).to have_css('form.mock-form ul.nav-tabs li a.active', text: tab)
end

Then /^The (.*) field of the mock form should have an error message "(.*)"$/ do |field, error|
  field_id = "duckrails_mock_#{field.parameterize.underscore}"
  expect(page).to have_css "form.mock-form div.#{field_id} .invalid-feedback", text: error
end

When /^I click the (General|Response body|Headers|Advanced) tab of the mock form$/ do |tab|
  click_on tab
end

When /^I fill in the (.*) field of the mock form with value "([^"]*)"$/ do |field, value|
  field_id = "duckrails_mock_#{field.parameterize.underscore}"
  fill_in field_id, with: value
end

When /^I select the value "([^"]*)" on the (.*) of the mock form$/ do |value, field|
  field_id = "duckrails_mock_#{field.parameterize.underscore}"
  select value, from: field_id
end
