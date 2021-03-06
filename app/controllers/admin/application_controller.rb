# frozen_string_literal: true

module Admin
  # All Administrate controllers inherit from this `Admin::ApplicationController`,
  # making it the ideal place to put authentication logic or other
  # before_actions.
  #
  # If you want to add pagination or other controller-level concerns,
  # you're free to overwrite the RESTful controller actions.
  class ApplicationController < Administrate::ApplicationController
    include HandlePundit

    before_action :authenticate_admin

    def authenticate_admin
      raise Pundit::NotAuthorizedError unless current_user&.has_role?(:admin)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
