require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class BA
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 5

    def scrape_data
      result = []
      visit "https://www.shopping.ba.com/az"
      page.all('.btn-group.bootstrap-select.has-text')[1].click
      sleep 1
      page.all('li a span.text')[3].click
      sleep 5.5
      page.all('.merch-full').each do |pm|
        merch_name = pm.find('span.merch-title').text
        value = pm.find('span.merch-rates').text
        link = pm.all('a')[0][:href]
        voucher = pm.all('span.ico-voucher').size > 0
        offer = pm.all('span.ico-offer').size > 0
        result << { merch_name: merch_name, value: value, link: link, voucher: voucher, offer: offer }
      end
      Capybara.reset_sessions!
      result
    end
  end
end