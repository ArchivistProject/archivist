class MetadataField::Boolean < MetadataField
  TYPE = 'true/false'.freeze
  # TODO: Actually use below options array, it should be used to generate the select options in the frontend
  # Once in place it can be used for ENUM types, just will be dynamically created options rather than static
  OPTIONS = [
              { label: 'false', value: 0 },
              { label: 'true', value: 1 }
  ].freeze
end
