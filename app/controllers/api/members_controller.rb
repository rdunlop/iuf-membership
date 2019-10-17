# frozen_string_literal: true

module Api
  # Handle queries from 3rd party system about membership in the IUF
  class MembersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :skip_authorization

    def status
      member = MemberFinder.find_paid(
        first_name: params[:first_name],
        last_name: params[:last_name],
        birthdate: params[:birthdate]
      )

      if member
        render json: { member: true, iuf_member_id: format('IUF%05d', member.iuf_id) }
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
