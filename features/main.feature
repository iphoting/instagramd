Feature: Main Page

Scenario: Loading the main page
	Given I am on the main page
	Then the page should be loaded with a url box

Scenario: Inputting an invalid url
	Given I am on the main page
	When I enter an invalid url
	Then the page should say "Invalid URL entered!"

@wip
# Failing, IG API requires login.
Scenario: Inputting a valid url
	Given I am on the main page
	When I enter a valid url: https://www.instagram.com/p/CEzSoQNMdfH/
	Then the page should load with the url and an image from Instagram.
