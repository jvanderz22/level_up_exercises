Given /^the bomb is booted with activation code "(.+)"$/ do |code|
  step 'the bomb is not booted'
  fill_in(:activation_code, :with => code)
  click_on('Boot')
end

When /^I enter activation code "(.+)"$/ do |code|
  fill_in(:activation_code, :with => code)
end

When /^I attempt to activate the bomb$/ do
  click_on('Activate')
end

