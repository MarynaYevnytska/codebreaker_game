# frozen_string_literal: true

module Validate
  def string?(object)
    check = begin
                Integer(object)
            rescue StandardError
              false
              end
    'Value is not string' if check
  end

  def number?(object)
    check = begin
                Integer(object)
            rescue StandardError
              false
              end
    'Value is not number' unless check
  end

  def length_valid?(object, range)
    'Wrong length!' unless range.include?(object.length)
  end

  def all_validations_for_string(object, range)
    errors = []
    errors << length_valid?(object, range)
    errors << string?(object)
    puts errors.compact
    errors.compact.empty?
  end

  def all_validations_for_number(object, range)
    errors = []
    errors << length_valid?(object, range)
    errors << number?(object)
    puts errors.compact
    errors.compact.empty?
  end
end
