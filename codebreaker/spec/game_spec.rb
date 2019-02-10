RSpec.describe Codebreaker::Game do
  let!(:game) { described_class.new('Maryna', Codebreaker::Game::DIFF[:easy]) }
  let!(:difficulty) { game.difficulty }
  let!(:processor) { Codebreaker::Processor.new(Codebreaker::Game::DIFF[:easy]) }
  let!(:console) { Codebreaker::Console.new }
  let!(:no_hint) { Codebreaker::Game::SEND_TO_CONSOLE[:no_hints] }
  let(:number) { '1' * Codebreaker::Game::DIGIT }
  let(:no_number) { 'a' * Codebreaker::Game::DIGIT }
  let(:attempts) { Codebreaker::Game::DIFF[:easy][:attempts] }

  context 'when game-process start ' do

    it 'when the variable `difficulty` is exist', positive: true do
      expect(difficulty.class).to eq(Hash)
    end

    it 'when the  difficulty contains `difficulty name` && `difficulty`', positive: true do
      expect(difficulty.size).to eq(2)
    end

    it 'when the  difficulty contains `attempts` && `hints`', positive: true do
      expect(difficulty[:difficulty].size).to eq(2)
    end

    it 'when the variable `processor` is exist', positive: true do
      expect(processor.class).to eq(Codebreaker::Processor)
    end
  end

  context 'when secret code was generate' do
    it { expect(processor.secret_code).to be_instance_of(Array) }
    it { expect(processor.secret_code.size).to eq(Codebreaker::Game::DIGIT) }
  end

  context 'when user input is NUMBER', positive: true do

    before do
      allow_any_instance_of(Codebreaker::Console).to receive(:question).and_return(number)
    end

    it 'when guess handle' do
      expect(game).to receive(:valid?).and_return(true)
      game.guess_result(number)
    end

    it 'when guess handle' do
      expect(game).to receive(:guess_handle).and_return(instance_of(String))
      game.guess_result(number)
    end
  end

  context 'when user input is NO NUMBER', positive: true do

    before do
      allow_any_instance_of(Codebreaker::Console).to receive(:question).and_return(no_number)
    end

    it 'when validation does not pass' do
      expect(game).to receive(:valid?).and_return(false)
      game.guess_result(no_number)
    end

    it 'when handling of guess  return message `errors`' do
      expect(game).to receive(:guess_result).and_return('errors')
      game.guess_result(no_number)
    end

    it 'when guess handle return meesge `errors`' do
      allow(game).to receive(:guess_result).and_return('errors')
      expect(STDOUT).to receive(:puts).with(instance_of(Array))
      game.guess_result(no_number)
    end
  end

  context 'when user input is hint' do
    
    before do
      allow_any_instance_of(Codebreaker::Console).to receive(:question).and_return('hint')
    end

    it 'when user want to get hint and  hints are available' do
      expect(game).to receive(:hint_handle).once
      game.guess_result('hint')
    end

    it 'when value of current attemt change if user input is `hint` ' do
      expect { processor.hint }.to change(game, :current_hint).by(0)
      game.guess_result('hint')
    end

    it 'when current_hint is ZERO' do
      game.instance_variable_set(:@current_hint, 0)
      expect(STDOUT).to receive(:puts).with(I18n.t('no_hints'))
      game.guess_result('hint')
    end
  end
end
