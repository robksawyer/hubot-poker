# hubot-poker

# WARNING: This is not working at the moment. It's a work in progress.

# GOALS: See the TODO section of poker.coffee

Allow hubot to play a game of holdem.

See [`src/poker.coffee`](src/poker.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-poker --save`

Then add **hubot-poker** to your `external-scripts.json`:

```json
["hubot-poker"]
```

## Sample Interaction

```
user1>> hubot poker me
hubot>> Game started! Add some hands to the game via the 'add hand <username>' command.

user1>> hubot poker add @rob
hubot>> @rob added to the game.

user1>> hubot poker deal cards
hubot>> Good luck!

```
