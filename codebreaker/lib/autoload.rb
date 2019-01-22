# frozen_string_literal: true

require 'pry'
require 'colorize'
require 'i18n'
require 'yaml'
require_relative '../lib/modules/validate.rb'
require_relative '../lib/entities/game.rb'
require_relative '../lib/entities/console_game.rb'
require_relative '../lib/modules/validate.rb'
require_relative '../lib/modules/load.rb'
require_relative '../lib/entities/console_game.rb'
require_relative '../lib/entities/console.rb'
require_relative '../lib/codebreaker.rb'
I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
