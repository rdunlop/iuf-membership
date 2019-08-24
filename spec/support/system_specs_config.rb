# frozen_string_literal: true

require 'action_dispatch/system_testing/server'
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :selenium_remote do |app|
  Capybara::Selenium::Driver.new(app,
                                 url: 'http://chrome:4444/wd/hub',
                                 browser: :remote,
                                 desired_capabilities: :chrome)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by(:selenium_remote)
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 4000
    ip = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
    host! "http://#{ip}:#{Capybara.server_port}"
    Capybara.app_host = "http://#{ip}:4000"
  end
end

Capybara.server = :webrick
Capybara.javascript_driver = :selenium_remote
