Given /^the bomb is exploded$/ do
  step 'the bomb is booted with deactivation code "0000"'
  step 'the bomb is activated'
  3.times do
    step 'I enter deactivation code "1111"'
    step 'I attempt to deactivate the bomb'
  end
end

Then /^there should be nothing for a user to interact with$/ do
  expect(page).to have_no_content("Activate")
  expect(page).to have_no_content("Deactivate")
  expect(page).to have_no_content("Boot")
end
