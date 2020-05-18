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
end

RSpec.configure do |config|
  config.include SystemHelper, type: :system
end
