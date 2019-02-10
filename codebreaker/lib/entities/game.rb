# frozen_string_literal: true

module Codebreaker
  class Game
    include Validate

    USER_INPUT = { user_input_is_hint: 'hint' }.freeze
    SEND_TO_CONSOLE = {
      no_hints: 'no_hints',
      win: 'win'
    }.freeze

    DIGIT = 4
    ZERO = 0
    DIFF = {
      easy: {
        name: 'Easy',
        difficulty: {
          hints: 2,
          attempts: 15
        }
      },

      medium: {
        name: 'Medium',
        difficulty: {
          hints: 1,
          attempts: 10
        }
      },

      hell: {
        name: 'Hell',
        difficulty: {
          hints: 1,
          attempts: 5
        }
      }
    }.freeze

    attr_reader :name, :difficulty, :secret_code, :errors
    attr_accessor :messages, :game, :current_hint, :current_attempt, :game_status, :hints_used, :attempts_used

    def initialize(name, difficulty)
      @name = name
      @difficulty = difficulty
      @current_hint = difficulty[:difficulty][:hints].to_i
      @current_attempt = 1
      @processor = Codebreaker::Processor.new(difficulty)
    end

    def fetch_secret_code
      @secret_code = @processor.secret_code.join
    end

    def guess_result(user_input)
      valid?(user_input) ? guess_handle(user_input) : Console::MENU[:errors]
    end

    def to_hash
      count_statistics
      {
        player_name: @name,
        level: @difficulty[:name],
        all_hints: @difficulty[:hints],
        all_attempts: @difficulty[:attempts],
        used_hints: @hints_used,
        used_attempts: @attempts_used,
        date: Time.now
      }
    end

    private

    def valid?(user_input)
      user_input == USER_INPUT[:user_input_is_hint] ? true : validate_number(user_input, DIGIT..DIGIT)
    end

    def guess_handle(user_input)
      user_input == USER_INPUT[:user_input_is_hint] ? hint_handle : @processor.compare(user_input)
    end

    def hint_handle
      case @current_hint
      when ZERO then SEND_TO_CONSOLE[:no_hints]
      when 1..@difficulty[:difficulty][:hints].to_i then view_hint(@current_hint)
      end
    end

    def view_hint(current_hint)
      current_hint -= 1
      @current_hint = current_hint
      @processor.fetch_hint
    end

    def validate_number(object, range)
      @errors = []
      @errors << length_valid?(object, range)
      @errors << number?(object)
      @errors.compact.empty?
    end

    def count_statistics
      @attempts_used = @current_attempt - 1
      @hints_used = difficulty[:difficulty][:hints] - @current_hint
    end
  end
end
