require 'rspec'
require 'capybara/rspec'
require 'capybara/dsl'
require 'selenium-webdriver'
#TEST_ENVIRONMENT='JV2'
TEST_ENVIRONMENT='production'
PRODUCTION = (TEST_ENVIRONMENT == 'production' ? true : false)
JV2 = (TEST_ENVIRONMENT == 'JV2' ? true : false)

def visit_url(environment, path, id, page)
  p = page
  local_path = (environment == 'production' ? (path + '?') : '?NavPoint=APPLY&')
  visit local_path + id
  click_link p.apply_for_loan if PRODUCTION
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  if TEST_ENVIRONMENT == 'production' then
    config.app_host = 'https://www.salliemae.com?' # change url
  else
    config.app_host = "https://opennetwld-qa6.salliemae.com/W2WPortal?"
  end
end
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
RSpec.configure do |config|
  config.include Capybara::DSL
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
