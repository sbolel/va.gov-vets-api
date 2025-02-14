# frozen_string_literal: true

module TempFormValidation
  extend ActiveSupport::Concern

  included do
    attr_accessor(:form)

    validates(:form, presence: true, on: :create)
    validate(:form_matches_schema, on: :create)
  end

  def parsed_form
    @parsed_form ||= JSON.parse(form)
  end

  private

  def form_matches_schema
    if form.present?

      JSON::Validator.fully_validate(VetsJsonSchema::SCHEMAS[self.class::FORM_ID], parsed_form).each do |v|
        errors.add(:form, v.to_s)
      end
    end
  end
end
