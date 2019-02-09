# frozen_string_literal: true
module Codebreaker
  class Console
    include Load
    include Validate

    MENU = {
      exit: 'exit',
      errors: 'errors',
      game_rules: 'rules',
      game_start: 'start',
      goodbye: 'goodbye',
      no: 'n',
      no_hints: 'no_hints',
      save?: 'save?',
      stats: 'stats',
      win: 'win',
      yes: 'y'
    }.freeze

    NAME_RANGE = (3..20).freeze
    FILE_NAME_ST = './stat.yml'

    attr_reader :errors, :game, :difficulty_value

    def initialize
      @output ||= Outputer.new
      @output.show_greeting_message
    end

    def question(message = 'user_answer')
      print I18n.t(message)
      user_input
    end

    def main_menu
      loop do
        case question('choose_the_command')
        when MENU[:exit] then goodbye
        when MENU[:game_rules] then show_rules
        when MENU[:game_start] then return start_game
        when MENU[:stats] then show_stats
        else
          @output.wrong_choice
        end
      end
    end

    private

    def show_rules
      @output.show_rules
    end

    def show_stats
      print_statistic
    end

    def start_game
      @game = Codebreaker::Game.new(name, difficulty)
      game_progress
    end

    def name
      validate_name.capitalize
    end

    def validate_name
      loop do
        name = user_input_name
        return name if validate_string(name, NAME_RANGE)
      end
    end

    def user_input_name
      @output.show_name_requirements
      question('user_answer')
    end

    def user_input
      user_input = gets.chomp
      user_input == MENU[:exit] ? goodbye : user_input
    end

    def difficulty
      difficulty_menu
      case @difficulty_value.capitalize
      when Game::DIFF[:easy][:name] then Game::DIFF[:easy]
      when Game::DIFF[:medium][:name] then Game::DIFF[:medium]
      when Game::DIFF[:hell][:name] then Game::DIFF[:hell]
      end
    end

    def difficulty_menu
      @output.show_difficulty_menu
      Game::DIFF.each_value do |value|
        @output.show_difficulty_list(value: value)
      end
      loop do
        @difficulty_value = question 'user_answer'
        return if Game::DIFF.key?(@difficulty_value.to_sym)
      end
    end

    def game_progress
      @output.start
      while game_state_valid?
        game_status = @game.guess_result(question)
        case game_status
          when MENU[:win] then break
          when MENU[:errors]
          puts game.errors.compact unless game.errors.empty?
          next
          when MENU[:no_hints] then @output.show_in_console('no_hints')
          when Integer then @output.show_hint(game_status)
        else
          @output.show_result_of_comparing(game_status)
          game.current_attempt += 1
        end
      end
      game_over(fetch_statistics, game_status)
    end

    def fetch_statistics
      @game.to_hash
    end

    def print_statistic
      load_statistics(FILE_NAME_ST).each_with_index do |value, index|
        @output.show_statistics(value, index)
      end
    end

    def game_state_valid?
      @game.current_attempt <= @game.difficulty[:difficulty][:attempts]
    end

    def validate_string(object, range)
      @errors = []
      @errors << length_valid?(object, range)
      @errors << string?(object)
      puts @errors.compact
      @errors.compact.empty?
    end

    def game_over(game_statistics, game_status)
      game_status == MENU[:win] ? user_winner(game_statistics) : computer_winner
      save?(game_statistics)
    end

    def user_winner(game_statistics)
      show_in_console('win')
      loop do
        case question(MENU[:save?])
        when MENU[:yes]
          save(game_statistics, FILE_NAME_ST)
          break
        when MENU[:no] then main_menu
        else
          show_in_console('wrong_choice')
        end
      end
      main_menu
    end

    def computer_winner
      @output.show_computer_winner(@game.fetch_secret_code)
      loop do
        case question('continue?')
        when MENU[:yes] then main_menu
        when MENU[:no]  then goodbye
        else
          show_in_console('wrong_choice')
        end
      end
    end

    def goodbye
      abort MENU[:goodbye]
    end
  end
end
