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

end
