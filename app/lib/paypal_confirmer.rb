# frozen_string_literal: true

# Based on
# https://developer.paypal.com/docs/checkout/integrate/#6-verify-the-transaction
#
# When a order is received, we will create a payment record in the db to match
class PaypalConfirmer
  include PayPalCheckoutSdk::Orders

  # Create a payment record in our database
  # for the payment provided
  def create_payment(paypal_order_details) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    purchase_unit = paypal_order_details[:purchase_units][0]
    custom_id = purchase_unit[:custom_id]
    member = Member.find_by(id: custom_id)
    if member.nil?
      Rollbar.debug('Unable to find member to mark paid', custom_id: custom_id)
      return false
    end

    member.payments.create(
      order_id: paypal_order_details[:id],
      amount_cents: purchase_unit[:amount][:value].to_f * 100,
      currency: purchase_unit[:amount][:currency_code],
      received_at: paypal_order_details[:create_time]
    )
    member.update(iuf_id: MemberNumberCreator.allocate_number) if member.iuf_id.blank?
  end

  # unused function which allows us to look up an order from paypal
  def get_order_details(order_id)
    # Create an order request to get the order details from PayPal
    request = OrdersGetRequest.new(order_id)
    # Call PayPal to get the transaction
    result = PayPalClient.client.execute(request)
    PayPalClient.openstruct_to_hash(result)
  end

  # ===================================

  # Capture a given order in paypal
  #
  # params: order_id - paypal Order number
  #                    used to fetch/capture a payment
  #
  # On success, return the order representation
  # as a hash object
  # On failure return false
  def capture(order_id) # rubocop:disable Metrics/MethodLength
    request = OrdersCaptureRequest.new(order_id)
    request.prefer('return=representation')
    begin
      response = PayPalClient.client.execute(request)
      unless [200, 201].include?(response.status_code)
        Rollbar.debug('Unsuccessful paypal capture attempt', capture: response)
        return false
      end

      return PayPalClient.openstruct_to_hash(response.result)
    rescue StandardError => e
      Rollbar.error(e)
    end

    false
  end
end
