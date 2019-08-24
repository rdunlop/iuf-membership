# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  after_action :verify_authorized, unless: %i[devise_controller?]
end
