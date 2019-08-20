class PaypalController < ApplicationController
  # Ignore CSRF Token on this request
  skip_before_action :verify_authenticity_token

  def confirm
    PaypalConfirmer.new.confirm(params[:orderID])
  end
end
