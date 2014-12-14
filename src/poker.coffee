# Description
#   Allow hubot to play a game of holdem.
#
# Configuration:
#   None
#
# Commands:
#   hubot poker me - Start a game of Texas Holdem!
#   hubot poker deal card - Deal two cards
#   hubot poker add <user> - Add a user to the game
#   hubot poker stat - Print the game stats
#   hubot poker river - River
#   hubot poker game - Get the game stats in JSON format
#   hubot poker save - Saves the game
#
# Notes:
#   This depends heavily on the module poker-sim (https://www.npmjs.com/package/poker-sim).
#
# Author:
#   robksawyer

pokerSim = require "poker-sim"
game = ""

module.exports = (robot) ->
  robot.respond /(poker|play holdem|start poker) ( me)?/i, (msg) ->
    game = new pokerSim.Game();
    msg.reply "Game started! Add some hands to the game via the 'add hand <username>' command."

  #Add the player to the hand
  robot.respond /poker add (@?([\w .\-]+)\?*$| me)/i, (msg) ->
    user = msg.match[1]
    if user.trim() == "me"
      users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      game.addHand #{user}
    msg.send #{user} + " added to the game."

  #Deal two cards (getting fancy with this and trying to add more or less than 2 will probably get you in trouble)
  #TODO: Count the players and deal cards appropriately.
  robot.respond /poker deal card(s)?/i, (msg) ->
    msg.send game.dealCard().dealCard()

  #call evalHands() to process win percentages using the current state of the game
  robot.respond /poker eval/i, (msg) ->
    msg.send game.evalHands()

  #Deal two cards (getting fancy with this and trying to add more or less than 2 will probably get you in trouble)
  robot.respond /poker stat(us)?/i, (msg) ->
    msg.send game.printGame()

  #River
  robot.respond /poker river/i, (msg) ->
    msg.send game.communityCard()

  #At any time you can return the JSON of the game status
  robot.respond /poker game/i, (msg) ->
    msg.send game.getGame()

  #TODO: Save the game to robot.brain. 
  robot.respond /poker save/i, (msg) ->
    msg.send game.getSave()




