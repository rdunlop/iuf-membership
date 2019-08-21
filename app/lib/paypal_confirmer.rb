# frozen_string_literal: true

# https://developer.paypal.com/docs/checkout/integrate/#6-verify-the-transaction
class PaypalConfirmer
  include PayPalCheckoutSdk::Orders

  # 2. Set up your server to receive a call from the client
  # You can use this function to retrieve an order by passing order ID as an argument
  # rubocop:disable Rails/Output
  def confirm(order_id) # rubocop:disable Metrics/AbcSize
    request = OrdersGetRequest.new(order_id)
    # 3. Call PayPal to get the transaction
    response = PayPalClient.client.execute(request)
    # 4. Save the transaction in your database. Implement logic to save transaction to your database for future reference.
    puts 'Status Code: ' + response.status_code.to_s
    puts 'Status: ' + response.result.status
    puts 'Order ID: ' + response.result.id
    puts 'Intent: ' + response.result.intent
    puts 'Links:'
    response.result.links.each do |link|
      # You could also call this link.rel or link.href, but method is a reserved keyword for RUBY. Avoid calling link.method.
      puts "\t#{link['rel']}: #{link['href']}\tCall Type: #{link['method']}"
    end
    puts 'Gross Amount: ' + response.result.purchase_units[0].amount.currency_code + response.result.purchase_units[0].amount.value
  end
  # rubocop:enable Rails/Output
end
