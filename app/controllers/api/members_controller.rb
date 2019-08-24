# frozen_string_literal: true

module Api
  # Handle queries from 3rd party system about membership in the IUF
  class MembersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :skip_authorization

    def status
      bday = Date.parse(params[:birthdate])
      member = Member.find_by(
        first_name: params[:first_name],
        last_name: params[:last_name],
        birthdate: bday
      )

      if member&.active?
        render json: { found: true }
      else
        render json: {}
      end
    end
  end
end
