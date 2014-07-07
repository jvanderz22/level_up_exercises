Capybara.default_driver = :selenium

Given /^the bomb is not booted$/ do
  visit('/')
  click_on('Reset')
end

Given /^an entered valid activation code$/ do
  fill_in(:activation_code, :with => '1234')
end

Given /^an entered valid deactivation code$/ do
  fill_in(:deactivation_code, :with => '0000')
end

When /^I don't enter an activation code$/ do
end

When /^I don't enter a deactivation code$/ do
end

When /^I enter a 4 digit activation code$/ do
  fill_in(:activation_code, :with => '1234')
end

When /^I enter a 4 digit deactivation code$/ do
  fill_in(:deactivation_code, :with => '0000')
end

When /^I enter "(.+)" as an activation code$/ do |code|
  fill_in(:activation_code, :with => code)
end

When /^I enter "(.+)" as a deactivation code$/ do |code|
  fill_in(:activation_code, :with => code)
end

When /^I attempt to boot the bomb$/ do
  click_button('Boot')
end

