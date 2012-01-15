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
    ai = new @BasicAI()
    ai.requires = [card]
      
    @game = new @State().setUpWithOptions [ai],
      colonies: false
      log: () ->
    @player = @game.players[0]

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
    @player.hand = @parseCards(cards)
    next()

  # Given I wish to buy a Province
  #
  # Sets the AI player's so that it wants to gain the given card (or nothing)
  @Given /^I wish to buy(?:a |an )? (.*)/, (card, next) ->
    priority = @parseCards(card)
    @player.ai.gainPriority = -> priority
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

