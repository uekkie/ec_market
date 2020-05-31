class Merchants::ApplicationController < ApplicationController
  before_action :authenticate_merchant!
end
