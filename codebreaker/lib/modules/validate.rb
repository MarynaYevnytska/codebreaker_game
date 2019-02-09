# frozen_string_literal: true

module Validate
  def string?(object)
    check = begin
                Integer(object)
            rescue StandardError
              false
              end
    I18n.t 'no_string' if check
  end

  def number?(object)
    check = begin
                Integer(object)
            rescue StandardError
              false
              end
    I18n.t 'no_number' unless check
  end

  def length_valid?(object, range)
    I18n.t('wrong_length') unless range.include?(object.length)
  end
end
