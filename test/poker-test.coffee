chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'poker', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/poker')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/(poker|play holdem|start poker) ( me)?/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker add (@?([\w .\-]+)\?*$| me)/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker deal card(s)?/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker eval/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker stat(us)?/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker river/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker game/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/poker save/i)

