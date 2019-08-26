# frozen_string_literal: true

module Api
  # Handle queries from 3rd party system about membership in the IUF
  class MembersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :skip_authorization

    def status
      member = find_member(params)

      if member&.active?
        render json: { member: true, iuf_member_id: 'temporary-fake-12345' }
      else
        render json: { member: false }
      end
    end

    private

    def find_member(params)
      bday = Date.parse(params[:birthdate])

      Member.find_by(
        first_name: params[:first_name],
        last_name: params[:last_name],
        birthdate: bday
      )
    end
  end
end
