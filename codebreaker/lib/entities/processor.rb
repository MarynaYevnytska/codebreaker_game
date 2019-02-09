# frozen_string_literal: true

module Codebreaker
  class Processor
    NUM_RANGE = 6
    PLUS = '+'
    MINUS = '-'
    WIN = 'win'

    attr_reader :difficulty, :secret_code, :secreet_code_clone

    def initialize(difficulty)
      @difficulty = difficulty
      @secret_code = create_secret_code
      @secreet_code_clone = @secret_code.shuffle
    end

    def compare(user_input)
      case user_input.chars
      when @secret_code then WIN
      else
        plus_minus_factoring(user_input)
      end
    end

    def fetch_hint
      remainder = @secreet_code_clone.pop(@secreet_code_clone.length - 1)
      hint = @secret_code - remainder
      @secreet_code_clone = remainder
      hint[0].to_i
    end

    private

    def create_secret_code
      Array.new(Game::DIGIT).map! { |_number| rand(NUM_RANGE).to_s }
    end

    def plus_factor(user_input)
      @answer_plus = []
      @remainder_plus_factor = user_input.chars
      user_input.chars.each_with_index do |val_user, ind_user|
        @secret_code.each_with_index do |val_sec, ind_sec|
          if val_sec == val_user && ind_user == ind_sec
            @answer_plus.push(PLUS)
            @remainder_plus_factor[ind_user] = nil
          end
        end
      end
    end

    def minus_factor
      @answer_minus = []
      @secret_code.each_with_index do |val_sec, _ind_sec|
        @remainder_plus_factor.each_with_index do |val_user, ind_user|
          next unless val_sec == val_user

          @answer_minus.push(MINUS)
          if @secret_code.count(val_sec) == @remainder_plus_factor.count(val_sec)
            @remainder_plus_factor[ind_user] = NUM_RANGE + 1
          else
            @remainder_plus_factor.map! { |item| item == val_sec ? NUM_RANGE + 1 : item }
          end
        end
      end
    end

    def plus_minus_factoring(user_input)
      plus_factor(user_input)
      minus_factor
      @answer_plus.push(@answer_minus).join
    end
  end
end
