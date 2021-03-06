require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class JetBlue
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 20, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 15

    def scrape_data
      result = []
      visit "http://shoptrue.jetblue.com/az"
      page.all('a.sbSelector')[1].click
      page.all('ul.sbOptions li a')[4].click
      sleep 3
      # save_and_open_page
      page.all('.merch-item').each do |pm|
        merch_name = pm.find('span.merch-title').text
        value = pm.find('span.merch-rates').text
        link = pm.all('a')[0][:href]
        coupons = pm.all('span .ico-voucher').size > 0
        offer = pm.all('span .ico-offer').size > 0
        result << { merch_name: merch_name, value: value, link: link, coupons: coupons, offer: offer }
      end
      Capybara.reset_sessions!
      result
    end
  end
end