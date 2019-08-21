# frozen_string_literal: true

# After a payment callback is received, before we consider it
# paid, we check to ensure that it's a real payment.
class PaypalController < ApplicationController
  # Ignore CSRF Token on this request
  skip_before_action :verify_authenticity_token

  def confirm
    PaypalConfirmer.new.confirm(params[:orderID])
  end
end
