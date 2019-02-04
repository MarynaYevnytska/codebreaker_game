RSpec.describe Codebreaker::Console do
  let!(:console) { described_class.new }
  let!(:game) { Codebreaker::Game.new(Codebreaker::Console::DIFF[:easy]) }
  let!(:yes) { Codebreaker::Console::MENU[:yes] }
  let!(:start) { Codebreaker::Console::MENU[:game_start] }
  let!(:stats) { Codebreaker::Console::MENU[:statistics] }
  let(:s_code) { [1, 1, 1, 1] }
  let(:game_statistics) { instance_of(Hash) }

  context 'when game progress user see   messages' do
    specify { expect { described_class.new }.to output(print(I18n.t('greeting'))).to_stdout }
    specify { expect { console.answer_for_user('anything')}.to output(print('anything')).to_stdout }
  end
  it 'when user get message and should input  answer  to console' do
    allow(STDIN).to receive(:gets).and_return('')
    expect(console.question('')).to eq('')
  end

  context 'when user does choice' do
    before (:each)do
      allow(console).to receive(:loop).and_yield
    end
    after (:each) do
      console.main_menu
    end
    it 'when `start` and input name' do
      allow(console).to receive(:question).and_return('start')
      expect(STDOUT).to receive(:puts).with(I18n.t('name', min: Codebreaker::Console::NAME_RANGE.first, max: Codebreaker::Console::NAME_RANGE.last))
    end
    it 'when `start` and chooses difficulty' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      expect(STDOUT).to receive(:puts).with(I18n.t('difficulty', count_difficulty: Codebreaker::Console::DIFF.size))
    end
    it 'when user  press `start`' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty).and_return(Codebreaker::Console::DIFF[:hell])
      allow(Codebreaker::Game).to receive(:new).and_return(game)
      expect(console).to receive(:start_game).once
    end
    it 'when game start' do
      allow(console).to receive(:question).and_return('start')
      allow(console).to receive(:name).and_return('Len')
      allow(console).to receive(:difficulty).and_return(Codebreaker::Console::DIFF[:hell])
      allow(Codebreaker::Game).to receive(:new).and_return(game)
      expect(STDOUT).to receive(:puts).with(I18n.t('start'))
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
      #allow(console).to receive(:question).and_return('exit')
      #expect(STDOUT).to receive(:puts).with(MENU[:goodbye])
    end
    it 'when user chooses smt' do
      allow(console).to receive(:question).and_return('bla-bla-bla')
      expect(STDOUT).to receive(:puts).with(I18n.t('wrong_choice'))
    end
  end
end
