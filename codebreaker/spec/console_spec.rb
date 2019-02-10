RSpec.describe Codebreaker::Console do
  let!(:console) { described_class.new }
  let!(:outputer) { Codebreaker::Outputer.new }
  let!(:game) { Codebreaker::Game.new('Maryna', Codebreaker::Game::DIFF[:easy]) }
  let!(:yes) { Codebreaker::Console::MENU[:yes] }
  let!(:start) { Codebreaker::Console::MENU[:game_start] }
  let!(:stats) { Codebreaker::Console::MENU[:statistics] }
  let!(:game_statistics) { instance_of(Hash) }
  let!(:wrong_input) { 'bla-bla-bla' }
  let!(:win) { 'win' }
  let!(:hint) { 1 }

  context 'when game progress user see   messages' do
    specify { expect { described_class.new }.to output(print(I18n.t('greeting'))).to_stdout }
  end

  context 'when user does choice' do
    before (:each) do
      allow(console).to receive(:loop).and_yield
    end

    after (:each) do
      console.main_menu
    end

    it 'when user choice is `start` next step is input of name' do
      allow(console).to receive(:question).and_return(Codebreaker::Console::MENU[:game_start])
      expect(console.errors.compact.empty?).to eq(true)
    end

    it 'when user choice is `start` next step is input of name' do
      allow(console).to receive(:question).and_return(Codebreaker::Console::MENU[:game_start])
      expect(STDOUT).to receive(:puts).with(I18n.t('name', min: Codebreaker::Console::NAME_RANGE.first, max: Codebreaker::Console::NAME_RANGE.last))
    end

    it 'when `start` and chooses difficulty' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      expect(STDOUT).to receive(:puts).with(I18n.t('difficulty', count_difficulty: Codebreaker::Game::DIFF.size))
    end

    it 'when user authorization is valid and game start' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty).and_return(Codebreaker::Game::DIFF[:hell])
      allow(Codebreaker::Game).to receive(:new).and_return(game)
      expect(console).to receive(:game_progress).once
    end

    it 'when game start' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty).and_return(Codebreaker::Game::DIFF[:hell])
      allow(Codebreaker::Game).to receive(:new).and_return(game)
      expect(STDOUT).to receive(:puts).with(I18n.t('start'))
    end

    it 'when user won and game over' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty).and_return(Codebreaker::Game::DIFF[:hell])
      allow(Codebreaker::Game).to receive(:new).and_return(game)
      allow(game).to receive(:guess_result).and_return(win)
      expect(console).to receive(:game_over).once
    end

    it 'when user choose difficulty' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty_menu).and_return(Codebreaker::Game::DIFF[:hell][:name])
      expect(console.difficulty).to eq(Game::DIFF[:hell])
    end

    it 'when user choose difficulty' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      console.instance_variable_set(:@difficulty_value, Codebreaker::Game::DIFF[:medium][:name])
      expect(console.difficulty).to eq(Game::DIFF[:medium])
    end

    it 'when user choose difficulty' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty_menu).and_return(Codebreaker::Game::DIFF[:easy][:name])
      expect(console.difficulty).to eq(Game::DIFF[:easy])
    end

    it 'when user chooses `rules`' do
      allow(console).to receive(:question).and_return('rules')
      expect(STDOUT).to receive(:puts).with(I18n.t('rules'))
    end

    it 'when user chooses `stats`' do
      allow(console).to receive(:question).and_return('stats')
      expect(STDOUT).to receive(:puts).with(instance_of(String))
    end

    it 'when user chooses `exit`' do
      # allow(console).to receive(:question).and_return('exit')
      # expect(STDOUT).to receive(:puts).with(MENU[:goodbye])
    end

    it 'when user chooses smt' do
      allow(console).to receive(:question).and_return(wrong_input)
      expect(STDOUT).to receive(:puts).with(I18n.t('wrong_choice'))
    end
  end

  it 'when hint is not available' do
    allow(console).to receive(:loop).and_yield
    allow(console).to receive(:question).and_return('start')
    allow(console).to receive(:name).and_return('Len')
    allow(console).to receive(:difficulty).and_return(Codebreaker::Game::DIFF[:hell])
    allow(Codebreaker::Game).to receive(:new).and_return(game)
    allow(game).to receive(:guess_result).and_return(Codebreaker::Console::MENU[:no_hints])
    expect(STDOUT).to receive(:puts).with(I18n.t('no_hints'))
  end

  it 'when hint is available' do
    allow(console).to receive(:loop).and_yield
    allow(console).to receive(:question).and_return('start')
    allow(console).to receive(:name).and_return('Len')
    allow(console).to receive(:difficulty).and_return(Codebreaker::Game::DIFF[:hell])
    allow(Codebreaker::Game).to receive(:new).and_return(game)
    allow(game).to receive(:guess_result).and_return(hint)
    expect(outputer).to receive(:show_hint)
  end
end
