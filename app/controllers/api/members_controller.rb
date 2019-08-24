# frozen_string_literal: true

module Api
  class MembersController < ApplicationController
    skip_before_action :verify_authenticity_token

    def status
      if Member.find_by(
        first_name: params[:first_name],
        last_name: params[:last_name],
        birthdate: params[:birthdate]
      )
        render json: { found: true }
      else
        render json: {}
      end
    end
  end
end
