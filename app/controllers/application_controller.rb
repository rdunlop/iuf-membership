# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  after_action :verify_authorized, unless: %i[devise_controller?]

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:agree_to_privacy_policy])
  end
end
