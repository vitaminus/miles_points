require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class Spirit
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 5

    def scrape_data
      result = []
      visit "http://mall.spirit.com/az"
      page.all('.btn-group.bootstrap-select.has-text')[1].click
      page.all('a span.text')[5].click
      sleep 4
      page.all('.merch-full').each do |pm|
        merch_name = pm.find('span.merch-title')[:title]
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