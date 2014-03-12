Given(/^a tic\-tac\-toe feature file and a step file$/) do
  cuke = <<CUKE
  	Given I have a started Tic-Tac-Toe game
  		And it is the computer's turn
  		And the computer is playing X
  	Then the computer randomly chooses an open position for its move
  		And the board should have an X on it
CUKE
  @cuke_lines = cuke.split("\n")
  steps = <<STEP
Given /^I have a started Tic\-Tac\-Toe game$/ do
  @game = TicTacToe.new(:player)
  @game.player = "Renee"
end

Given /^it is the computer's turn$/ do
  @game = TicTacToe.new(:computer, :O)
  @game.current_player.should eq "Computer"
end

Given /^the computer is playing X$/ do
  @game.computer_symbol.should eq :X
end

Then /^the computer randomly chooses an open position for its move$/ do
  open_spots = @game.open_spots
  @com_move = @game.computer_move
  open_spots.should include(@com_move)
end

Then /^the board should have an X on it$/ do
  @game.current_state.should include 'X'
end
STEP
  @step_lines = steps.split("\n")
end

When(/^I slice them\.$/) do
  @cs = CucumberSlices.new
  @cs.extract_steps @step_lines
  @output = @cs.splice_features @cuke_lines
end

Then(/^The program should return lines of the cuke followed by the steps$/) do
  @output[0].should == "1 #{@cuke_lines[0]}"
  @output[1].should == "  \t#{@step_lines[1]}"
  @output[2].should == "  \t#{@step_lines[2]}"
  @output[3].should == "2 #{@cuke_lines[1]}"
  @output[4].should == "  \t\t#{@step_lines[6]}"
  @output[5].should == "  \t\t#{@step_lines[7]}"
end
