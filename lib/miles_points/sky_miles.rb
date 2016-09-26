require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class SkyMiles
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 5

    def scrape_data
      result = []
      visit "http://www.skymilesshopping.com/b____.htm"
      sleep 4.5
      page.all('.mn_merchantGroup').each do |pm|
        pm.all('li').each do |mp|
          merch_name = mp.find('span.mn_merchName').text
          value = mp.find('span.mn_rebateValueWithCurrency').text
          link = mp.find('li a')[:href]
          result << { merch_name: merch_name, value: value, link: link }
        end
      end
      Capybara.reset_sessions!
      result
    end
  end
end