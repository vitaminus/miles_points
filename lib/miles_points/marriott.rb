require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class Marriott
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 15, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 10

    def scrape_data
      result = []
      visit "https://marriott.rewards.com/earnpoints/allMerchants"
      sleep 5
      page.all('.merchant-container-list').each do |pm|
        merch_name = pm.all('a')[1].text
        value = pm.find('.merchant-cashback').text
        link = pm.all('a')[0][:href]
        coupons = pm.all('.merchant-coupons img').size > 0
        result << { merch_name: merch_name, value: value, link: link, coupons: coupons }
      end
      Capybara.reset_sessions!
      result
    end
  end
end