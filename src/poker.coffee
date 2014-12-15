# Description
#   Allow hubot to play a game of holdem in Slack.
#
# Configuration:
#   SLACK_API_TOKEN - Your team's Slack API token. You may be able to find this @ https://api.slack.com/tokens.
#
# Commands:
#   hubot (play poker|play holdem) - Start a game of Texas Holdem!
#   hubot deal card - Deal two cards
#   hubot add player <user> - Add a user to the game
#   hubot poker stat - Print the game stats
#   hubot poker river - River
#   hubot poker game - Get the game stats in JSON format
#   hubot poker save - Saves the game
#
# Notes:
#   This depends heavily on the module poker-sim (https://www.npmjs.com/package/poker-sim).
#
# TODOs:
#   Once a game is started, a private message should be sent to the user that started the game. The user will get instructions that 
#   tell them how to add a hand to the game. Other users/players can join the game via the addHand command. Once they are added,
#   a private message is sent to them that lets them know they've been added.
#   
#   After all users are in the game, cards are dealt and private messages are sent to them telling them which cards they have in their hand.
#   
# Author:
#   robksawyer

pokerSim = require "poker-sim"
ws = require 'websocket-stream'

#Global game instance
game = undefined

#Slack endpoint URL
rtm_endpoint = "https://slack.com/api/rtm.start"

#Slack stream
stream = undefined 

module.exports = (robot) ->

  startSlackRTMConnection, () ->
    #Start a RTM session on Slack
    #Send authenticated request to Slack
    robot.http(rtm_endpoint)
      .query(
        token: process.env.SLACK_API_TOKEN
      )
      .get() (err, res, body) ->
        if err 
          msg.reply "Had an error setting up the game. :("
          robot.emit 'error', err, msg
          return
        # Send a private message to user that started the game letting them know that they have been added.
        result =  JSON.parse(body)
        if result and result.ok
          #The Websocket URLs provided by rtm.start are single-use and are only valid for 30 seconds, so make sure to connect quickly.
          stream = ws(result.url)
        else 
          msg.send "There was an error connecting to Slack"
          return

  #TODO: Actually get this to work. Not really sure what I'm doing here.
  sendSlackMessage, () ->
    console.log "Sending a message to @" + result.self.id
    #Send a message 
    #https://api.slack.com/rtm (See Sending Messages)
    message = {
      id: 1,
      type: "message",
      text: "Welcome to the game!",
      user: result.self.id
    }
    stream.once 'data', (data) ->
      console.log data

    stream.once 'error', (err) ->
      console.log err

    stream.write(JSON.stringify(message))

  #Starts a game
  robot.respond /(play|start)? (poker|holdem)( me)?/i, (msg) ->
    if game
      msg.reply "The game has already started."

    game = new pokerSim.Game()
    players = robot.brain.get('players')
    #Add the user that started the game automatically 
    game.addHand msg.message.user.name
    robot.brain.set 'players', players+1
    msg.reply "Game started! Add some hands to the game via the 'add hand <username>' command."

  #Add the player to the hand
  robot.respond /add player (@?([\w .\-]+)\?*$| me)/i, (msg) ->
    user = msg.match[1]
    unless user?
      msg.send "There was an issue adding the user to the game. Time to roll up your sleeves and start debugging."
      return

    #Get the current number of players
    players = robot.brain.get('players')
    if user.trim() == "me"
      user = msg.message.user
      console.log user
      robot.brain.set 'players', players+1
      msg.send game.addHand user
      return
    else 
      users = robot.brain.usersForFuzzyName(user)
      if users and users.length is 1
        user = users[0]
        console.log user
        robot.brain.set('players', players+1)
        msg.send game.addHand user
        return
    

  #Deal two cards (getting fancy with this and trying to add more or less than 2 will probably get you in trouble)
  #TODO: Count the players and deal cards appropriately.
  robot.respond /deal ( a| some| the)?card(s)?/i, (msg) ->
    result = game.dealCard().dealCard()
    msg.send result.toString()

  #call evalHands() to process win percentages using the current state of the game
  robot.respond /poker eval/i, (msg) ->
    result = game.evalHands()
    msg.send result.toString()

  #Deal two cards (getting fancy with this and trying to add more or less than 2 will probably get you in trouble)
  robot.respond /poker stat(us)?/i, (msg) ->
    result = game.printGame()
    msg.send result.toString()

  #River
  robot.respond /poker river/i, (msg) ->
    result = game.communityCard()
    msg.send result.toString()

  #At any time you can return the JSON of the game status
  robot.respond /get game/i, (msg) ->
    result = game.getGame()
    msg.send result.toString()

  #TODO: Save the game to robot.brain. 
  robot.respond /poker save ( game)?/i, (msg) ->
    result = game.getSave()
    robot.brain.set('lastgame', result)
    msg.send result.toString




