exports.World = (callback) ->
  {@State} = require '../../gameState'
  {@BasicAI} = require '../../basicAI'
  {@c} = require '../../cards' if exports?

  # Allows us to record data from calls into the BasicAI to observe choices
  @TestAI = class extends @BasicAI
    constructor: ->
      @choices = {}

    choose: (type, state, choices) ->
      result = super
      @choices[type] ||= []
      @choices[type].push result
      result

  # Given a plain-English list of cards, separated by commas and/or an "and",
  # returns an array of card instances corresponding to the list
  #
  # For example:
  # >>> @parseCards('two Coppers, a Silver and three Estates')
  # [c.Copper, c.Copper, c.Silver, c.Estate, c.Estate, c.Estate]
  #
  # Cards may be pluralized (so far only adding an 's' is supported).  Each
  # card must have a quantity indicator (a, an, three, etc)
  @parseCards = (str) ->
    # Split on English list separators (commas followed by spaces or " and "
    # or ", and ")
    items = str.split(/, (?:and )?| and /)

    numberWords = [
      /no|zero/, /a|an|one/, /two/, /three/, /four/, 
      /five/, /six/, /seven/, /eight/, /nine/, /ten/
    ]

    result = []
    for item in items
      [__, quantity, cardName] = item.match(/(\w+) (.*)/)
      i = 0
      cardNameSingular = cardName.replace(/s$/, '')
      card = @c[cardName] || @c[cardNameSingular]
      until quantity.match(numberWords[i]) or i == numberWords.length
        i += 1
        result.push(card)

      throw "Unrecognized quantity: #{quantity}" if i == numberWords.length

    result

  # Tests if two arrays contain the same objects in the same order
  @arraysEqual = (a, b) ->
    a == b or !(a < b || b < a)

  # Asserts that two lists of cards are equal.  Raises an exception if they are not
  # The 'name' is the name of the card list.  For instance 'hand' may be the name
  # of the player's hand.  This produces more meaningful errors.
  @assertCardListsEqual = (name, expected, actual) ->
    unless @arraysEqual(expected, actual)
      aNames = card.name for card in expected
      bNames = card.name for card in actual
      throw "Expected #{name} to contain #{expected}, got #{actual}"

  callback(this)
