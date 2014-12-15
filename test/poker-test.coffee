chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

#The heart
pokerSim = require 'poker-sim'

expect = chai.expect

describe 'poker', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/poker')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/(play holdem|play poker) ( me)?/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/add player (@?([\w .\-]+)\?*$| me)/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/deal ( a| some| the)?card(s)?/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker eval/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker stat(us)?/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker river/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/get game/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker save ( game)?/i)


  it 'play a game', ->
    
    game = new pokerSim.Game()

    #add "Hands" or players
    game.addHand("Peter").addHand("Darren").addHand("Jim").addHand("Frank")

    #Deal two cards (getting fancy with this and trying to add more or less than 2 will probably get you in trouble)
    game.dealCard().dealCard()

    #call evalHands() to process win percentages using the current state of the game
    game.evalHands()

    #output the status of the game to the console
    game.printGame()

    #flop (3 cards)
    game.communityCard().communityCard().communityCard()

    #eval and print
    game.evalHands().printGame()

    #turn
    game.communityCard()

    #eval and print
    game.evalHands().printGame()

    #river
    game.communityCard()

    #eval and print
    game.evalHands().printGame()

    #at any time you can return the JSON of the game status
    result = game.getGame()
    console.log result
    #expect(result.eval.Frank).to.equal(1)
