require 'rspec'
require 'selenium-webdriver'
require 'capybara'

d=Selenium::WebDriver.for :chrome
d.navigate.to 'http://salliemae.com'
#e=d.find_element(name: 'q')
#e.send_keys("Hello World of Automation")
#e=d.find_element(name: 'f')
#e.submit
sleep(4)
d.close
