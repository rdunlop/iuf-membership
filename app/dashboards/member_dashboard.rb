# frozen_string_literal: true

require 'administrate/base_dashboard'

# Display the members in the /admin pages
class MemberDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    # audits: Field::HasMany.with_options(class_name: "Audited::Audit"),
    user: Field::BelongsTo,
    payments: Field::HasMany.with_options(export: false),
    id: Field::Number.with_options(export: false),
    first_name: Field::String,
    alternate_first_name: Field::String,
    last_name: Field::String,
    alternate_last_name: Field::String,
    birthdate: Field::DateTime.with_options(transform_on_export: ->(field) { field.data.strftime('%Y/%m/%d') }),
    contact_email: Field::String,
    created_at: Field::DateTime.with_options(export: false),
    updated_at: Field::DateTime.with_options(export: false),
    iuf_id: Field::Number.with_options(export: false),
    active?: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    first_name
    last_name
    payments
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    iuf_id
    first_name
    last_name
    birthdate
    contact_email
    alternate_first_name
    alternate_last_name
    active?
    payments
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user
    first_name
    last_name
    birthdate
    contact_email
    alternate_first_name
    alternate_last_name
    iuf_id
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

  # Overwrite this method to customize how members are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(member)
    member.to_s
  end
end
