require 'capybara/cucumber'

Given /I am on the main page/ do
  visit('/')
end

Then /the page should be loaded with a url box/ do
	expect(page).to have_field('url', type: 'url')
	expect(page).to have_button('Get image!')
end

When /I enter an invalid url/ do
	fill_in 'url', with: 'a'
	click_button 'Get image!'
end

When /I enter a valid url: (.+)/ do |url|
	fill_in 'url', with: url
	click_button 'Get image!'
end

Then /the page should say "(.+)"/ do |url|
	expect(page).to have_text(url)
end

Then /the page should load with the url and an image from Instagram/ do
	expect(page).to have_text('https://www.instagram.com/p/CEuOki3sjtW/')
end
