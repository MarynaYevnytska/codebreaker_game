# frozen_string_literal: true

RSpec.describe Codebreaker::ConsoleGame do
  let!(:console_game) { described_class.new('Maryna', Codebreaker::Console::DIFF[:easy]) }
  let!(:name) { console_game.name }
  let!(:difficulty) { console_game.difficulty }
  let!(:messages) { console_game.messages }
  let!(:game) { console_game.game }
  let!(:console) { Codebreaker::Console.new }
  let!(:no_hint) { Codebreaker::ConsoleGame::USER_ANSWER[:no_hints] }
  let(:number) { '1' * Codebreaker::ConsoleGame::DIGIT }

  context 'when game start ' do
    it 'when the variable `name` is exist', positive: true do
      expect(name.class).to eq(String)
    end
    it 'when the variable `difficulty` is exist', positive: true do
      expect(difficulty.class).to eq(Hash)
    end
    it 'when the  difficulty contains `difficulty name` && `difficulty`', positive: true do
      expect(difficulty.size).to eq(2)
    end
    it 'when the  difficulty contains `attempts` && `hints`', positive: true do
      expect(difficulty[:difficulty].size).to eq(2)
    end
    it 'when the variable `messages` is exist', positive: true do
      expect(messages.class).to eq(Console)
    end
    it 'when the variable `game` is exist', positive: true do
      expect(game.class).to eq(Game)
    end
    it 'when the value of difficulty moved from console_game to game', positive: true do
      expect(difficulty == game.difficulty).to eq(true)
    end
  end
  context 'when user input is NUMBER', positive: true do
    before do
      allow_any_instance_of(Console).to receive(:question).and_return(number)
    end
    it 'when user won the game and calls game_over with secret code, statistics and status' do
      allow_any_instance_of(Game).to receive(:compare).and_return('win')
      expect(messages).to receive(:game_over).with(kind_of(Array), { attempts_total: 15, attempts_used: 15, difficulty: 'Easy', hints_total: 2, hints_used: 0, user_name: 'Maryna' }, 'win')
      console_game.game_progress
    end
    it 'when computer won the guess and game continue' do
      allow_any_instance_of(Game).to receive(:compare).and_return('++--')
      expect(messages).to receive(:answer_for_user).with('++--').once
      console_game.game_progress
    end
    it 'when attempt was used if user input is number ' do
      # allow_any_instance_of(Game).to receive(:compare).and_return('++--')
      # expect { game.compare(number) }.to change(console_game, :current_attempt).by(+1)
      # console_game.game_progress TODO this test do failure test in game_spec
    end
    it 'when attemts сame  to end and game over' do
      allow_any_instance_of(Game).to receive(:compare).and_return('++--')
      console_game.instance_variable_set(:@current_attempt, Console::DIFF[:easy][:attempt])
      expect(messages).to receive(:game_over).with(kind_of(Array), { attempts_total: 15, attempts_used: 15, difficulty: 'Easy', hints_total: 2, hints_used: 0, user_name: 'Maryna' }, 'failure')
    end
  end
  context 'when user input is hint' do
    before do
      allow_any_instance_of(Console).to receive(:question).and_return('hint')
    end
    it 'when user want to get hint and  hints are available' do
      allow_any_instance_of(Game).to receive(:hint).and_return(1)
      expect(messages).to receive(:answer_for_user).with(I18n.t(USER_ANSWER[:hint_is], hint: 1)).once
      console_game.game_progress
    end
    it 'when user want to get hint but all the hints was used' do
      # console_game.instance_variable_set(:@current_hint, 0)
      # allow_any_instance_of(Console).to receive(:question).and_return('hint')
      # expect(STDOUT).to receive(:puts).with(I18n.t(no_hint))
      # console_game.game_progress TODO this test do failure test in game_spec
    end
    it 'when guess wasn`t used if user input is hint ' do
      expect { game.compare }.to change(console_game, :current_attempt).by(0)
    end
    it 'when value of current attemt change if user input is `hint` ' do
      expect { game.compare }.to change(console_game, :current_hints).by(-1)
    end
  end
  it 'when loop-while testing hint-integer' do
    allow(console_game).to receive(:guess_result).once.and_return(1)
    expect(console).to receive(:guess_result).once
    console_game.game_progress
  end
  it 'when loop-while testing no hint' do
    allow(console_game).to receive(:guess_result).once.and_return(no_hint)
    expect(console).to receive(:guess_result).once
    console_game.game_progress
  end
  it 'when user want to exit and press `exit`' do
    allow_any_instance_of(Console).to receive(:question).and_return('exit')
    expect(messages).to receive(:goodbye).once
    console_game.game_progress
  end
end
