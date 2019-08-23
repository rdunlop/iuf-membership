# frozen_string_literal: true

# Based on
# https://developer.paypal.com/docs/checkout/integrate/#6-verify-the-transaction
#
# When a order is received, we will create a payment record in the db to match
class PaypalConfirmer
  include PayPalCheckoutSdk::Orders

  # Retrieve order details from paypal
  # and then confirm the payment in our db
  def confirm(order_id)
    paypal_order_details = get_order_details(order_id)
    create_payment(paypal_order_details)
  end

  def create_payment(paypal_order_details)
    if paypal_order_details[:status_code] == 200
      result = paypal_order_details[:result]
      member = Member.find_by(id: result[:custom_id])
      if member.nil?
        # error
        return false
      end

      member.payments.create(
        order_id: result[:id],
        amount_cents: result[:amount][:value].to_f * 100,
        currency: result[:amount][:currency_code],
        received_at: result[:create_time]
      )
    else
      # Error
      false
    end
  end

  def get_order_details(order_id)
    # Create an order request to get the order details from PayPal
    request = OrdersGetRequest.new(order_id)
    # Call PayPal to get the transaction
    result = PayPalClient.client.execute(request)
    PayPalClient.ostruct_to_hash(result)
  end
end
