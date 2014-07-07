Then /^I should see "(.+)"$/ do |text|
  expect(page).to have_content(text)
end

Then /^the bomb should be "(.+)"$/ do |status|
  expect(page).to have_content("status is #{status}")
end

Then /^the page should have a "(.+)" button$/ do |button|
  expect(page).to have_selector(:link_or_button, button)
end

