Feature: Vault
  As a Dominiate AI
  I want to be able to play Vault rationally

# Broken
Scenario: Playing Vault with adequate money in hand
  Given I am playing a game with Vault in the Kingdom
  And I wish to buy a Province
  And I have a Vault, two Golds, a Silver, and an Estate in my hand
  Then I should not play Vault

# Broken
Scenario: Opponent plays Vault while player is unlikely to gain from discarding
  Given I am playing a game with Vault in the Kingdom
  And I have five Coppers in my hand
  And I have no Gold in my deck
  When my opponent plays Vault
  Then I should choose not to discard 2 cards

Scenario: Opponent plays Vault and discarding will lose desirable cards
  Given I am playing a game with Vault in the Kingdom
  And I wish to buy a Province
  And I have four Silvers and an Estate in my hand
  When my opponent plays Vault
  Then I should choose not to discard 2 cards


