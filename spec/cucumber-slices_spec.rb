require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'ruby-debug'
require './lib/cucumber-slices'

cuke = <<CUKE
	Given I have a started Tic-Tac-Toe game
		And it is the computer's turn
		And the computer is playing X
	Then the computer randomly chooses an open position for its move
		And the board should have an X on it
CUKE
cuke_lines = cuke.split("\n")
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
step_lines = steps.split("\n")

describe "CucumberSlices" do
  it "can extract the regexp from a line of a step file" do
    pending
  end
  it "can compine the output" do
    cs = CucumberSlices.new
    cs.extract_steps step_lines
    splice = cs.splice_features cuke_lines
    puts splice
    splice[0].should == "1 #{cuke_lines[0]}"
    splice[1].should == "\t#{step_lines[1]}"
  end
end
