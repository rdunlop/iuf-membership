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

  def create_payment(paypal_order_details) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    return false unless paypal_order_details[:status_code] == 200

    result = paypal_order_details[:result]
    purchase_unit = result[:purchase_units][0]
    custom_id = purchase_unit[:custom_id]
    member = Member.find_by(id: custom_id)
    return false if member.nil?

    member.payments.create(
      order_id: result[:id],
      amount_cents: purchase_unit[:amount][:value].to_f * 100,
      currency: purchase_unit[:amount][:currency_code],
      received_at: result[:create_time]
    )
    member.update(iuf_id: MemberNumberCreator.allocate_number) if member.iuf_id.blank?
  end

  def get_order_details(order_id)
    # Create an order request to get the order details from PayPal
    request = OrdersGetRequest.new(order_id)
    # Call PayPal to get the transaction
    result = PayPalClient.client.execute(request)
    PayPalClient.openstruct_to_hash(result)
  end
end
