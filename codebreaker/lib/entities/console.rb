# frozen_string_literal: true

module Codebreaker
  class Console
    include Load
    include Validate

    MENU = { exit: 'exit',
             errors: 'errors',
             game_rules: 'rules',
             game_start: 'start',
             goodbye: 'goodbye',
             no: 'n',
             no_hints: 'no_hints',
             save?: 'save?',
             stats: 'stats',
             win: '++++',
             yes: 'y' }.freeze
    DIFF = { easy: { name: 'Easy', difficulty: { hints: 2, attempts: 15 } },
             medium: { name: 'Medium', difficulty: { hints: 1, attempts: 10 } },
             hell: { name: 'Hell', difficulty: { hints: 1, attempts: 5 } } }.freeze

    NAME_RANGE = (3..20).freeze
    FILE_NAME_ST = './stat.yml'

    attr_accessor :current_attempt, :game
    attr_reader :errors

    def initialize
      @output=Outputer.new
      @output.greeting
    end

    def answer_for_user(answer)
      puts answer
    end

    def question(message = I18n.t('user_answer'))
      print message
      user_input
    end

    def main_menu
      loop do
        input = question(I18n.t('choose_the_command'))
        case input
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
      @output.rules
    end

    def show_stats
      print_statistic
    end

    def start_game
      @name = name
      @game = Codebreaker::Game.new(difficulty)
      game_progress
    end

    def name
      validate_name.capitalize
    end

    def validate_name
      loop do
        name = user_input_name
        return name if all_validations_for_string(name, NAME_RANGE)
      end
    end

    def user_input_name
      @output.name_requirements
      question(I18n.t('user_answer'))
    end

    def user_input
      user_input = gets.chomp
      user_input == MENU[:exit] ? goodbye : user_input
    end

    def difficulty
      difficulty_menu
      case @difficulty_value.capitalize
      when DIFF[:easy][:name] then DIFF[:easy]
      when DIFF[:medium][:name] then DIFF[:medium]
      when DIFF[:hell][:name] then DIFF[:hell]
      end
    end

    def difficulty_menu
      loop do
        @output.difficulty_list_size
        DIFF.each_value do |value|
          @output.difficulty_list(name: value[:name], attempts: value[:difficulty][:attempts],
                   hints: value[:difficulty][:hints])
        end
        @difficulty_value = question I18n.t('user_answer')
        return if DIFF.key?(@difficulty_value.to_sym)
      end
    end

    def game_progress
      @output.start
      @current_attempt = 1
      while game_state_valid?
        game_status = @game.guess_result(question)
        case game_status
        when MENU[:win] then break
        when MENU[:errors]
          puts game.errors.compact unless game.errors.empty?
          next
        when MENU[:no_hints] then answer_for_user(I18n.t('no_hints'))
        when Integer then answer_for_user(I18n.t('hint_is', hint: game_status))
        else
          answer_for_user(game_status)
          @current_attempt += 1
        end
      end
      game_over(statistics, game_status)
    end

    def statistics
      attempts_used = @current_attempt - 1
      hints_used = @game.difficulty[:difficulty][:hints] - @game.current_hint
      { "user_name": @name,
        "difficulty": @game.difficulty[:name],
        "attempts_total": @game.difficulty[:difficulty][:attempts],
        "attempts_used": attempts_used,
        "hints_total": @game.difficulty[:difficulty][:hints],
        "hints_used": hints_used }
    end

    def print_statistic
      load_statistics(FILE_NAME_ST).each_with_index do |value, index|
        puts I18n.t('statistics', rating: index + 1,
                                  name: value[:user_name],
                                  difficulty: value[:difficulty],
                                  attempts_total: value[:attempts_total],
                                  attempts_used: value[:attempts_used],
                                  hints_total: value[:hints_total],
                                  hints_used: value[:hints_used])
      end
    end

    def game_state_valid?
      @current_attempt <= @game.difficulty[:difficulty][:attempts]
    end

    def all_validations_for_string(object, range)
      @errors = []
      @errors << length_valid?(object, range)
      @errors << string?(object)
      puts @errors.compact
      @errors.compact.empty?
    end

    def game_over(game_statistics, game_status)
      game_status == MENU[:win] ? user_winner(game_statistics) : computer_winner(game_status)
      save?(game_statistics)
    end

    def user_winner(game_statistics)
      answer_for_user(I18n.t('win'))
      loop do
        case question(I18n.t(MENU[:save?]))
        when MENU[:yes]
          save(game_statistics, FILE_NAME_ST)
          break
        when MENU[:no] then main_menu
        else
          answer_for_user(I18n.t('wrong_choice'))
        end
      end
      main_menu
    end

    def computer_winner(_game_status)
      answer_for_user(I18n.t('failure', secret_code: @game.secret_code))
      loop do
        case question(I18n.t('continue?'))
        when MENU[:yes] then main_menu
        when MENU[:no]  then goodbye
        else
          answer_for_user(I18n.t('wrong_choice'))
        end
      end
    end

    def goodbye
      abort MENU[:goodbye]
    end
  end
end
