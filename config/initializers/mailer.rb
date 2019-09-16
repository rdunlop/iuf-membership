# frozen_string_literal: true

if Rails.configuration.aws_access_key_id
  creds = Aws::Credentials.new(
    Rails.configuration.aws_access_key_id,
    Rails.configuration.aws_secret_access_key
  )

  Aws::Rails.add_action_mailer_delivery_method(:aws_sdk,
                                               credentials: creds,
                                               region: Rails.configuration.aws_region)

  ActionMailer::Base.delivery_method = :aws_sdk
end
