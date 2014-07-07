Given /^the bomb is booted with deactivation code "(.+)"$/ do |code|
  step "the bomb is not booted"
  fill_in(:deactivation_code, :with => code)
  click_button("Boot")
end

Given /^the bomb is activated$/ do
  fill_in(:activation_code, :with => "1234")
  click_button("Activate")
end

When /^I enter deactivation code "(.+)"$/ do |code|
  fill_in(:deactivation_code, :with => code)
end

When /^I attempt to deactivate the bomb$/ do
  click_button("Deactivate")
end

Then /^the page should have the number of failed deactivation attempts$/ do
  expect(page).to have_content("failed to deactivate the bomb 0 time(s)")
end

Then /^the page should say there is "(.+)" failed deactivation attempt$/ do |num|
  expect(page).to have_content("failed to deactivate the bomb #{num} time(s)")
end


