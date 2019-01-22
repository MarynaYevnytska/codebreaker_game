# frozen_string_literal: true
RSpec.describe Game do
    let!(:game) { described_class.new(Console::DIFF[:easy]) }
    let(:console_game) { ConsoleGame.new('Maryna', Console::DIFF[:easy]) }
    let!(:difficulty) { game.difficulty }
    let!(:secret_code) { game.secret_code }
    let!(:hint_clone_scode) { game.hint_clone_scode }
    let!(:win){ConsoleGame::MESSAGE_GU[:win]}
    let!(:digit){ConsoleGame::DIGIT}

    context 'when the game started and datas move to processor' do
      it 'when the variable `difficulty` is exist', positive: true do
        expect(difficulty.class).to eq(Hash)
      end
      it 'when the variable `secret_code` is exist', positive: true do
        expect(secret_code.class).to eq(Array)
      end
      it 'when the variable `hint_clone_scode` is exist', positive: true do
        expect(hint_clone_scode.class).to eq(Array)
      end
      it 'when the digit of `secret_code` is correct', positive: true do
        expect(secret_code.size).to eq(digit)
      end
      it 'when the digit of `secret_code` equal `hint_clone_scode` at the start', positive: true do
        expect(secret_code.size == hint_clone_scode.size).to eq(true)
      end
      it 'when the sequence of `secret_code` is not same as `hint_clone_scode`  at the start', positive: true do
        expect(game.hint_clone_scode != game.secret_code).to eq(true)
      end
    end
    context 'when user did a coorect input of number' do
      it 'when secret code equles user input, return game status `win`' do
        user_input = secret_code.join
        game.compare(user_input)
        expect(game.compare(user_input)).to eq(win)
      end
    end
    context 'when the method plus-minus factoring output correct value' do
      YAML.load_file('./spec/fixtures/game_test_data.yml').each do |item|
        it "when secret_code is #{item[0]} && the user input is #{item[1]}, the responds to consol will be #{item[2]}" do
          game.instance_variable_set(:@secret_code, item[0].join.chars)
          expect(game.compare(item[1].join)).to eq(item[2])
        end
      end
    end
    context 'when user get the hint' do
      it 'when hint is exists' do
        expect(game.hint).to be_instance_of(Integer)
      end
      it 'when  reminder after first hint is exists' do
        expect(game.hint_clone_scode).to be_instance_of(Array)
      end
      it 'when  hint_clone_scode reduces reminder  after first hint by 1' do
        expect { game.hint }.to change { game.hint_clone_scode.size }.by(-1)
      end
    end

end
