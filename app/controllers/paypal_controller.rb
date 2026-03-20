# frozen_string_literal: true

# After a payment is created, but before it is captured (charged)
# call this controller to capture/log the payment
class PaypalController < ApplicationController
  # Ignore CSRF Token on this request
  skip_before_action :verify_authenticity_token
  before_action :skip_authorization

  # Create a transaction and capture payment
  def create
    member = Member.find_by(id: params[:memberID])
    if member&.recent_purchase?
      render json: { success: false, message: 'A payment was already received for this member in the last 24 hours.' }
      return
    end

    result = PaypalConfirmer.new.capture(params[:orderID])
    if result
      PaypalConfirmer.new.create_payment(result)
      render json: { success: true, message: 'Order processed' }
    else
      render json: { success: false, message: 'Error processing order' }
    end
  end
end
