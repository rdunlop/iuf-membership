# frozen_string_literal: true

require 'administrate/base_dashboard'

# Display the Payments in the /admin pages
class PaymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    # audits: Field::HasMany.with_options(class_name: "Audited::Audit"),
    member: Field::BelongsTo,
    id: Field::Number,
    order_id: Field::String,
    received_at: Field::DateTime,
    amount_cents: Field::Number,
    currency: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    start_date: Field::Date,
    expiration_date: Field::Date,
    active?: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    member
    order_id
    active?
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    member
    order_id
    received_at
    amount_cents
    currency
    created_at
    updated_at
    start_date
    expiration_date
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    member
    order_id
    received_at
    amount_cents
    currency
    start_date
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how payments are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(payment)
    "Payment ##{payment.id} - #{payment.order_id}"
  end
end
