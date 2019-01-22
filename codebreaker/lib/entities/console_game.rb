# frozen_string_literal: true
MESSAGE_GU = { "attempt": 'user_answer',
               "nil": 'nil',
               "win": '++++', "failure": 'failure' }.freeze
USER_ANSWER = { "attempt": 'user_answer', "no_hints": 'no_hints', "hint_is": 'hint_is' }.freeze
MESSAGE_FOR_USER = { "start_game": 'guess', "failure": 'failure' }.freeze
DIGIT = 4

class ConsoleGame
  include Validate
  attr_reader :name, :difficulty
  attr_accessor :messages, :game, :current_hint, :current_attempt, :game_status
  def initialize(name, difficulty)
    @name = name
    @difficulty = difficulty
    @messages = Console.new(MESSAGE_FOR_USER[:start_game])
    @game = Game.new(difficulty)
  end

  def game_progress
    @current_hint = @difficulty[:difficulty][:hints].to_i
    @current_attempt = 1
    range = 1..@difficulty[:difficulty][:attempts].to_i
    while range.cover?(@current_attempt)
      @game_status = guess_result
      case @game_status
        when MESSAGE_GU[:win] then break
        when USER_ANSWER[:no_hints]
        @messages.answer_for_user(I18n.t(USER_ANSWER[:no_hints]))
        when Integer
        send_to_user = I18n.t(USER_ANSWER[:hint_is], hint: @game_status)
        @messages.answer_for_user(send_to_user)
      else
        @messages.answer_for_user(@game_status)
        @current_attempt += 1
      end
    end
    @messages.game_over(@game.secret_code, statistics, @game_status)
  end

  def guess_result
    valid_input = input_handle
    if valid_boolean(valid_input)
      valid_input
    else
      @game.compare(valid_input)
    end
  end

  private

  def valid_boolean(valid_input)
    valid_input.class == Integer || valid_input == USER_ANSWER[:no_hints] || valid_input.nil?
  end

  def statistics
    attempts_used = @current_attempt - 1
    hints_used = @difficulty[:difficulty][:hints] - @current_hint
    { "user_name": @name,
      "difficulty": @difficulty[:name],
      "attempts_total": @difficulty[:difficulty][:attempts],
      "attempts_used": attempts_used,
      "hints_total": @difficulty[:difficulty][:hints],
      "hints_used": hints_used }
  end

  def user_input
    @messages.question { I18n.t(USER_ANSWER[:attempt]) }
  end

  def input_validate(input)
    if errors_array_guess(input, (DIGIT..DIGIT))
      input
    else
      user_input
    end
  end

  def input_handle
    input = user_input
    case input
      when 'hint'
        case @current_hint
          when ZERO then USER_ANSWER[:no_hints]
          when 1..@difficulty[:difficulty][:hints].to_i then view_hint(@current_hint)
        end
      when 'exit' then @messages.goodbye
    else
      input_validate(input)
    end
  end

  def view_hint(current_hint)
    current_hint -= 1
    @current_hint = current_hint
    @game.hint
  end
end
