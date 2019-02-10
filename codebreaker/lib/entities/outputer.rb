module Codebreaker
  class Outputer
    def show_greeting_message
      print I18n.t('greeting')
    end

    def show_in_console(message)
      puts I18n.t(message)
    end

    def show_hint(hint)
      puts I18n.t('hint_is', hint: hint)
    end

    def show_result_of_comparing(game_status)
      puts I18n.t('attempt_result', game_status: game_status)
    end

    def show_computer_winner(secret_code)
      puts I18n.t('failure', secret_code: secret_code)
    end

    def show_rules
      puts I18n.t('rules')
    end

    def show_name_requirements
      puts I18n.t('name', min: Codebreaker::Console::NAME_RANGE.first, max: Codebreaker::Console::NAME_RANGE.last)
    end

    def show_difficulty_menu
      puts I18n.t('difficulty', count_difficulty: Game::DIFF.size)
    end

    def show_difficulty_list(value:)
      puts I18n.t('difficulty_item',
                  name: value[:name],
                  attempts: value[:difficulty][:attempts],
                  hints: value[:difficulty][:hints])
    end

    def show_statistics(value, index)
      puts I18n.t('statistics', rating: index + 1,
                                name: value[:user_name],
                                difficulty: value[:difficulty],
                                attempts_total: value[:attempts_total],
                                attempts_used: value[:attempts_used],
                                hints_total: value[:hints_total],
                                hints_used: value[:hints_used])
    end

    def start
      puts I18n.t('start')
    end

    def wrong_choice
      puts I18n.t('wrong_choice')
    end
  end
end
