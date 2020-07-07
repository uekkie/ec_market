module SystemHelper
  extend ActiveSupport::Concern

  included do |example_group|
    # Screenshots are not taken correctly
    # because RSpec::Rails::SystemExampleGroup calls after_teardown before before_teardown
    example_group.after do
      take_failed_screenshot
    end
  end

  def take_failed_screenshot
    return if @is_failed_screenshot_taken

    super
    @is_failed_screenshot_taken = true
  end

  def fill_stripe_elements(card:, expiry: '1234', cvc: '123', selector: '#card-element > div > iframe')
    find_frame(selector) do
      card.to_s.chars.each do |piece|
        find_field('cardnumber').send_keys(piece)
      end

      find_field('exp-date').send_keys expiry
      find_field('cvc').send_keys cvc
    end
  end

  # Completes SCA authentication successfully
  def complete_stripe_sca
    find_frame('body > div > iframe') do
      # This helps find the inner iframe in the SCA modal's challenge frame which doesn't load immediately
      sleep 1

      find_frame('#challengeFrame') do
        click_on 'Complete authentication'
      end
    end
  end

  # Fails SCA authentication
  def fail_stripe_sca
    find_frame('body > div > iframe') do
      # This helps find the inner iframe in the SCA modal's challenge frame which doesn't load immediately
      sleep 1

      find_frame('#challengeFrame') do
        click_on 'Fail authentication'
      end
    end
  end

  # Generic helper for finding an iframe
  def find_frame(selector, &block)
    using_wait_time(15) do
      frame = find(selector)
      within_frame(frame) do
        block.call
      end
    end
  end
end

RSpec.configure do |config|
  config.include SystemHelper, type: :system
end
