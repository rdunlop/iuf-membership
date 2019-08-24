# frozen_string_literal: true

# This is the welcome/landing page
class HomeController < ApplicationController
  before_action :skip_authorization

  def index; end
end
