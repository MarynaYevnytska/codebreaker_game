RSpec.describe Codebreaker::Console do
  let!(:console) { described_class.new }
  let!(:console_game) { Codebreaker::ConsoleGame.new('Maryna', DIFF[:easy]) }
  let!(:yes) { MENU[:yes] }
  let!(:start) { MENU[:start] }
  let!(:stats) { MENU[:statistics] }
  let(:s_code) { [1, 1, 1, 1] }
  let(:game_statistics) { instance_of(Hash) }

  context 'when gem run user see greeting message' do
    specify { expect { described_class.new }.to output(print(I18n.t('greeting'))).to_stdout }
  end
  it 'when user get answer to console' do
    allow(console).to receive(:answer_for_user).with('anything').once
    expect(STDOUT).to receive(:puts).with('anything').once
    console.answer_for_user('anything')
  end
  it 'when user get message and should input  answer  to console' do
    allow(STDIN).to receive(:gets) { 'Joe' }
    expect(console.question {}).to eq 'Joe'
  end
  it 'when user get message and should input  answer  to console' do
    allow(console).to receive(:question).with('anything?').once
    expect(STDOUT).to receive(:print).with('anything?')
  end
  context 'when game over' do
    before(:each) do
      allow(console).to receive(:game_over).with(s_code, game_statistics)
    end
    it 'when user watch message about game over ' do
      expect(STDOUT).to receive(:print).with("Secret code is #{s_code.join}")
      console.game_over(s_code, game_statistics)
    end
    it 'when user watch message about game over ' do
      expect(STDOUT).to receive(:print).with(I18n.t(MENU[:failure]))
      console.game_over(s_code, game_statistics)
    end
    it 'when user watch message about game over with status "win"' do
      expect(STDOUT).to receive(:puts).with(I18n.t(MENU[:win]))
      console.game_over(s_code, game_statistics, 'win')
    end
    it 'when user watch offer for saving' do
      expect(console).to receive(:save?).once
      console.game_over(s_code, game_statistics)
    end
    it 'when user saved/no sved and watch next question' do
      expect(console).to receive(:first_choice).once
      console.game_over(s_code, game_statistics)
    end
  end
  context 'when user choosen game start and  press `start`' do
    before (:each) do
      allow(console).to receive(:first_choice).and_return(yes)
      allow(console).to receive(:question).and_return(start).once
    end
    it 'when  method call' do
      expect(console).to receive(:start).once
      console.choice
    end
    it 'when insatance of game was created and name write down' do
      expect(console).to receive(:name).once
      console.start
    end
  end
  context 'when an user input is valid' do
    before(:each) do
      allow(console).to receive(:first_choice).and_return(yes)
    end
    it 'when user want to view statistics and press `stats`', positive: true do
      allow(console).to receive(:question).and_return(stats).once
      allow(console).to receive(:first_choice).and_return(MENU[:no])
      expect(STDOUT).to receive(:puts).with(I18n.t(stats)).twice
      console.choice
    end
    it 'when view rules  and press `rules`', positive: true do
      allow(console).to receive(:question).and_return(MENU[:game_rules]).once
      allow(console).to receive(:first_choice).and_return(MENU[:no])
      expect(console.choice).to receive(:puts).with(I18n.t(MENU[:game_rules]))
      console.choice
    end
    it 'when close app and press `goodbye`', positive: true do
      # allow(console).to receive(:question).and_return(MENU[:no])
      # expect(STDOUT).to receive(:puts).with(I18n.t(MENU[:goodbye]))
      # console.first_choice TODO this test do test for game failure
    end
    it 'when continue  and press `y`', positive: true do
      # allow(console).to receive(:question).and_return(yes)
      expect(STDOUT).to receive(:puts).with(I18n.t(MENU[:choice]))
      console.first_choice
    end
  end
  context 'when an user input is wrong', positive: true do
    it 'when is INvalid' do
      allow(console).to receive(:question).and_return('1111')
      expect(STDOUT).to receive(:puts).with(I18n.t(MENU[:choice]))
      console.choice
    end
    it 'when the start-menu was called and user can repeat an input', positive: true do
      allow(console).to receive(:question).and_return('wrong!')
      expect(STDOUT).to receive(:puts).with(I18n.t(MENU[:wrong!]))
    end
  end
end
