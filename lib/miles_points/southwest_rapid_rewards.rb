require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class SouthwestRapidRewards
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 5

    def scrape_data
      result = []
      visit "https://rapidrewardsshopping.southwest.com/b____.htm"
      sleep 5.5
      # save_and_open_page
      page.all('.mn_merchantGroup').each do |pm|
        pm.all('li').each do |mp|
          merch_name = mp.find('span.mn_merchName').text
          value = mp.find('span.mn_rebateValueWithCurrency').text
          merchant_id = mp.find('li a')['data-merchant-id']
          link = "https://rapidrewardsshopping.southwest.com/b____.htm#id=mn_overlay&merchantId=#{merchant_id}"
          result << { merch_name: merch_name, value: value, link: link } #"https://marketplace.plenti.com/me____.htm?#{link}"
        end
      end
      Capybara.reset_sessions!
      result
    end
  end
end