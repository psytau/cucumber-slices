Feature: View steps and cukes together
  As a programmer I want to read cuke files more easily
  In order to quickly match up the steps with the right cukes
  A programmer would like to see them together

  Scenario: View a cucumber-slice
    Given a tic-tac-toe feature file and a step file
    When I slice them.
    Then The program should return lines of the cuke followed by the steps
