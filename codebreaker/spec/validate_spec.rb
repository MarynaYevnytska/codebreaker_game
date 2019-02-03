RSpec.describe Validate do
  let(:dummy_class) { Class.new { extend Validate } }
  let(:number) { '1' * Codebreaker::ConsoleGame::DIGIT }
  let(:win) { 'win' }
  let(:min_down) { 'a' * (Codebreaker::Console::NAME_RANGE.first - 1) }
  let(:max_up) { 'a' * (Codebreaker::Console::NAME_RANGE.last + 1) }
  let(:number_up) { '1' * (Codebreaker::ConsoleGame::DIGIT + 1) }
  let(:zero) { 0 }
  let(:min) { 'a' * Codebreaker::Console::NAME_RANGE.first }
  let(:max) { 'a' * Codebreaker::Console::NAME_RANGE.last }
  let(:name_range) { Codebreaker::Console::NAME_RANGE }
  let(:digit) { Codebreaker::ConsoleGame::DIGIT }

  context 'when a LENGTH of user input is CORRECT', positive: true do
    it 'when a value of an user input of name is in a range && complete min-boundary value' do
      user_input = dummy_class.length_valid?(min, name_range)
      expect(user_input).to eq(nil) # :TODO why method always! return false or nil and never true
    end
    it 'when a value of an user input is less then max-boundary of value', positive: true do
      user_input = dummy_class.length_valid?(max, name_range)
      expect(user_input).to eq(nil) # :TODO why method always! return false or nil and never true
    end
  end

  context 'when an LENGTH of user input is WRONG!', negative: true do
    it 'when a value of an user input is NOT in a range && less then min-boundary value' do
      user_input = dummy_class.length_valid?(min_down, name_range)
      expect(user_input).to eq('Wrong length!')
    end
    it 'when a value of an user input is more then max-boundary value', negative: true do
      user_input = dummy_class.length_valid?(max_up, name_range)
      expect(user_input).to eq('Wrong length!')
    end
  end

  context 'when an user input is a STRING' do
    it 'when an user input is string', positive: true do
      user_input = dummy_class.string?(min)
      expect(user_input).to eq(nil)
    end
    it 'when an user input is NOT string', negative: true do
      user_input = dummy_class.string?(number.to_i)
      expect(user_input).to eq('Value is not string')
    end
  end

  context 'when an user input  NUMBER' do
    it 'when an user input is number', positive: true do
      user_input = dummy_class.number?(Integer(number))
      expect(user_input).to eq(nil)
    end
    it 'when an user input is NOT number', negative: true do
      user_input = dummy_class.number?(min)
      expect(user_input).to eq('Value is not number')
    end
  end

  context 'when an user inputted NAME' do
    it 'when an user input of name is CORRECT', positive: true do
      user_input = dummy_class.all_string_validates(min, name_range)
      expect(user_input).to eq(true)
    end
    it 'when an user input of name is INCORRECT', negative: true do
      user_input = dummy_class.all_string_validates(min_down, name_range)
      expect(user_input).to eq(false)
    end
  end

  context 'when an user inputted NUMBER' do
    it 'when an user input of number is CORRECT', positive: true do
      user_input = dummy_class.all_number_validates(number, digit..digit)
      expect(user_input).to eq(true)
    end
    it 'when an user input of number is INCORRECT', negative: true do
      user_input = dummy_class.all_number_validates(max_up, digit..digit)
      expect(user_input).to eq(false)
    end
  end

  context 'when an user inputted NUMBER' do
    it 'when an user input of number is CORRECT', negative: true do
      user_input = dummy_class.all_number_validates(number, digit..digit)
      expect(user_input).not_to eq(false)
    end
    it 'when an user input of number is INCORRECT', negative: true do
      user_input = dummy_class.all_number_validates(max_up, digit..digit)
      expect(user_input).to eq(false)
    end
  end
end
