class Admins::ApplicationsController < ApplicationController
  before_action :admin_signed_in?
end
