require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class JetCash
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 5

    def scrape_data
      result = []
      visit "https://jet.com/anywhere?category=All%20Categories"
      sleep 5
      within('.store_list') do
        page.all('.anywhere_col').each do |pm|
          merch_name = pm.find('.name').text
          value = pm.find('.percent').text
          link = pm.all('a')[0][:href]
          # coupons = pm.all('.merchant-coupons img').size > 0
          result << { merch_name: merch_name, value: value, link: link }
        end
      end
      Capybara.reset_sessions!
      result.sort_by { |hsh| hsh[:merch_name] }
    end
  end
end