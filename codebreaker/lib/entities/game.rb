# frozen_string_literal: true
module Codebreaker
  class Game
    include Validate
    USER_INPUT ={user_input_is_hint: 'hint'
              }.freeze
    SEND_TO_CONSOLE = { no_hints: 'no_hints',
                        win: 'win'
                }.freeze
    DIGIT = 4
    ZERO = 0

    attr_reader :name, :difficulty, :secret_code
    attr_accessor :messages, :game, :current_hint, :current_attempt, :game_status

    def initialize(name, difficulty)
      @difficulty = difficulty
      @current_hint = difficulty[:difficulty][:hints].to_i
      @core = Codebreaker::Core.new(difficulty)
    end

    def secret_code
      @secret_code=@core.secret_code.join
    end

    def guess_result(user_input)
      validation(user_input)? guess_handle(user_input) : Console::MENU[:errors]
    end

    private

    def validation(user_input)
      user_input==USER_INPUT[:user_input_is_hint]? true : all_validations_for_number(user_input, DIGIT..DIGIT)
    end

    def guess_handle (user_input)
     user_input==USER_INPUT[:user_input_is_hint]? hint_handle : @core.compare(user_input)
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
      @core.hint
    end

  end
end
