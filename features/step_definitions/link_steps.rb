Then /^I should( not)? see a (menu )?link with text '(.*)'$/ do |should_not, menu, link_text|
  selector = menu ? '.navbar-nav a' : '.body-content a'
  should_mode = should_not ? :not_to : :to
  expect(page).send(should_mode, have_css(selector, text: link_text))
end

When /^I click on the (menu )?link with text '(.*)'$/ do |menu, link_text|
  if menu
    page.find('.navbar-nav a', text: link_text).click
  else
    page.find('.body-content a', text: link_text).click
  end
end
