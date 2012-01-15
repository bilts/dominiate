Feature: Coutyard
  As a Dominiate AI
  I want to be able to play Courtyard rationally

Scenario: Courtyard should return extra money back to the deck
  Given I am playing a game with Courtyard in the Kingdom
  And I wish to buy a Province
  And I have a Courtyard, two Golds and two Estates in my hand
  And a Gold, a Silver and an Estate are on top of my deck
  When I play the Courtyard
  Then I should keep two Golds, a Silver and three Estates in my hand
  And I should place a Gold on top of my deck
  
