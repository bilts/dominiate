module.exports = ->
  @World = require("../support/world").World

  # Given I am playing a game with King's Court in the Kingdom
  #
  # Initializes a new game with a single AI, ensuring that the given
  # card is in the kingdom
  #
  # Sets @game (the current game state) and @player (the AI player state) for
  # subsequent steps to use
  @Given /^I am playing a game with (.*) in the Kingdom$/, (card, next) ->
    ai = new @TestAI()
    ai.requires = [card]
    opponent = new @TestAI()
      
    @game = new @State().setUpWithOptions [ai, opponent],
      colonies: false
      log: () ->
    @player = @game.players[0]

    for player in @game.players
      player.draw = []
      player.hand = []

    next()

  # Given a Copper, a Silver, and an Estate are on top of my deck
  # Given two Coppers are on top of my deck
  #
  # Places the given cards on top of the AI player's deck.
  @Given /^(.*) (?:is|are) on top of my deck$/, (cards, next) ->
    @player.draw.unshift(@parseCards(cards)...)
    next()

  # Given I have a Duchy and four Coppers in my hand
  #
  # Sets the contents of the AI player's hand to the given list of cards
  @Given /^I have (.*) in my hand$/, (cards, next) ->
    @startingHand = @parseCards(cards)
    @startingHand.sort()
    @player.hand = @startingHand.concat()
    next()

  # Given I wish to buy a Province
  #
  # Sets the AI player's so that it wants to gain the given card (or nothing)
  @Given /^I wish to buy(?:a |an )? (.*)/, (card, next) ->
    priority = @parseCards(card)
    @player.ai.gainPriority = -> priority
    next()

  # Given I have no Gold in my deck
  #
  # Removes any occurrences of the given card from the player's draw and
  # discard pile
  @Given /^I have no (.*) in my deck$/, (card, next) ->
    @player.draw = (c for c in @player.draw when c.name != card)
    @player.discard = (c for c in @player.discard when c.name != card)
    next()

  # When I play Menagerie
  #
  # Tells the game state to play the given card.  The card must be in the
  # player's hand.
  @When /^I play (?:the |a |my |)(.*)$/, (card, next) ->
    card = @c[card]
    @game.phase = 'action'
    @game.playAction(card)
    next()

  # Then I should not play Vault
  #
  # Asserts that the player did not put the given card into the play area
  # during his action phase
  @Then /^I should not play (?:the |a |my|)(.*)$/, (card, next) ->
    @game.doActionPhase()
    for playedCard in @player.inPlay
      if playedCard.name == card
        throw "#{card} should not have been played but was"
    next()

  # When my opponent plays Vault
  #
  # Switches to the opponent's turn's action phase and plays the given card.
  @When /^my opponent plays (?:the |a |my|)(.*)$/, (card, next) ->
    @game.rotatePlayer()
    card = @c[card]
    @game.phase = 'action'
    @game.playAction(card)
    next()

  # Then I should not choose to discard 2 cards
  #
  # Asserts that the player did not indicate that it was willing to discard
  # the given number of cards when prompted.
  @Then /^I should choose not to discard (\d+) card(?:s)?$/, (ncards, next) ->
    return next() unless @player.ai.choices['discard']
    # This is a little hack-ish.  We assert that the AI didn't return a card
    # for choose('discard', ...) ncards times.  This is generally right if only
    # one card has been played during the scenario.
    discarded = (c.name for c in @player.ai.choices['discard'] when c?)
    if discarded.length >= ncards
      throw "Player unexpectedly discarded #{discarded[0...ncards]}"
    next()

  # Then I should keep three Silvers and a Copper in my hand
  #
  # Asserts that the player's hand contents match the given list of cards.  The
  # language of this step makes sense in the case of discarding or putting back 
  # on deck.
  @Then /^I should keep (.*) in my hand$/, (cards, next) ->
    cards = @parseCards(cards)
    cards.sort()
    @player.hand.sort()
    @assertCardListsEqual('hand', cards, @player.hand)
    next()

  # Then I should place a Curse on top of my deck
  #
  # Asserts that the cards on top of the player's deck match the given list of
  # cards.  Order is important.  The first card listed corresponds to the top
  # of the deck.
  @Then /^I should place (.*) on top of my deck$/, (cards, next) ->
    cards = @parseCards(cards)
    @assertCardListsEqual('draw', cards, @player.draw[0...cards.length])
    next()
