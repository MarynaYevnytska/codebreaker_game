# frozen_string_literal: true

RSpec.describe Codebreaker::Processor do
  let!(:processor) { described_class.new(Codebreaker::Game::DIFF[:easy]) }
  let(:game) { Codebreaker::Game.new('Maryna', Codebreaker::Game::DIFF[:easy]) }
  let!(:difficulty) { processor.difficulty }
  let!(:secret_code) { processor.secret_code }
  let!(:secreet_code_clone) { processor.secreet_code_clone }
  let!(:digit) { Codebreaker::Game::DIGIT }

  context 'when the game started and datas move to processor' do
    
    it 'when the variable `difficulty` is exist', positive: true do
      expect(difficulty.class).to eq(Hash)
    end

    it 'when the variable `secret_code` is exist', positive: true do
      expect(secret_code.class).to eq(Array)
    end

    it 'when the variable `secreet_code_clone` is exist', positive: true do
      expect(secreet_code_clone.class).to eq(Array)
    end

    it 'when the digit of `secret_code` is correct', positive: true do
      expect(secret_code.size).to eq(digit)
    end

    it 'when the digit of `secret_code` equal `secreet_code_clone` at the start', positive: true do
      expect(secret_code.size == secreet_code_clone.size).to eq(true)
    end

    it 'when the sequence of `secret_code` is not same as `secreet_code_clone`  at the start', positive: true do
      expect(processor.secreet_code_clone != processor.secret_code).to eq(true)
    end
  end

  context 'when the method plus-minus factoring output correct value' do
    YAML.load_file('./spec/fixtures/game_test_data.yml').each do |item|
      it "when secret_code is #{item[0]} && the user input is #{item[1]}, the responds to consol will be #{item[2]}" do
        processor.instance_variable_set(:@secret_code, item[0].join.chars)
        expect(processor.compare(item[1].join)).to eq(item[2])
      end
    end
  end

  context 'when user get the hint' do

    it 'when hint is exists' do
      expect(processor.hint).to be_instance_of(Integer)
    end

    it 'when  reminder after first hint is exists' do
      expect(processor.secreet_code_clone).to be_instance_of(Array)
    end

    it 'when  secreet_code_clone reduces reminder  after first hint by 1' do
      expect { processor.hint }.to change { processor.secreet_code_clone.size }.by(-1)
    end
  end
end
