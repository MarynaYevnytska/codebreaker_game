module Codebreaker
  class Outputer

    def greeting
      print I18n.t('greeting')
    end

    def rules
      puts I18n.t('rules')
    end

    def name_requirements
      puts I18n.t('name', min: Codebreaker::Console::NAME_RANGE.first, max: Codebreaker::Console::NAME_RANGE.last)
    end

    def difficulty_list_size
      puts I18n.t('difficulty', count_difficulty: Codebreaker::Console::DIFF.size)
    end

    def difficulty_list(name:, attempts:, hints:)
      puts I18n.t('difficulty_item', name: name, attempts: attempts, hints: hints)
    end

    def start
      puts I18n.t('start')
    end

    def wrong_choice
      puts I18n.t('wrong_choice')
    end

  end

end
