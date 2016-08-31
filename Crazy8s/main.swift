import Foundation

//
// For Linux:
// swiftc -DDEBUG card.swift extensions.swift main.swift player.swift
//

let PLAYERS = 4

// How many cards do the players start with?
let CARDCOUNT = 8

//
// Set up the players first
//

var players = [Player]()

for idx in 1 ... PLAYERS {
	var player = Player()
	player.name = "Player \(idx)"
	players.append(player)
}

//
// Now set up the deck
//

var deck = createDeck()

// From the MutableCollectionType extension
deck.shuffle()

#if DEBUG
	for card in deck {
		print(card)
	}
#endif

//
// Now deal out the cards
//

var playerNum = 0
for cardNum in 1 ... (CARDCOUNT * PLAYERS) {
	var card = deck.removeFirst()
	players[playerNum].hand.append(card)
	playerNum += 1
	if playerNum == PLAYERS {
		playerNum = 0
	}
}

#if DEBUG
	for player in players {
		for card in player.hand {
			print("\(player.name) - \(card)")
		}
	}

	print("Deck has \(deck.count) cards")
#endif

// Okay, now let's begin the game...

// Our boolean to determine if anyone won
var gameOver = false

// Where the cards are gonna go...
var discardPile: [Card] = []

// First person to play is next to the dealer (which
// we will assume is 0)
var currentPlayer = 1

// And here begins the main loop
repeat {
	// Get the top card of the deck
	var turnOver = false
	repeat {
		// Do we have any cards in the deck?
		if deck.count == 0 {
			// No, the deck is empty, so we need to
			// transfer the discard pile back to the
			// main deck...
			deck = discardPile
			// And reshuffle the deck
			deck.shuffle()
			// And clear out the discard pile
			discardPile.removeAll()
		}

		// Pick up a card from the deck
		var currentCard = deck.removeFirst()

		// Can the player use this card?
		#if os(Linux)
			var turn = players[currentPlayer].canPlayOn(deckCard: currentCard)
		#else
			var turn = players[currentPlayer].canPlayOn(currentCard)
		#endif
		if turn.successful {
			// The player has a card that they can put on the
			// discard pile!
			discardPile.append(turn.card!)
			// And the player's turn is over
			turnOver = true
		} else {
			// The player does not have a playable card, so
			// we need to start pulling cards from the deck
			players[currentPlayer].hand.append(currentCard)
		}
	} while turnOver == false

	// Is the current player out of cards? If so, the game is over
	if players[currentPlayer].hand.count == 0 {
		// Yep, they're out of cards, so this player won!
		print("\(players[currentPlayer].name) won!")
		gameOver = true
	} else {
		// The current player's turn is over, and the game
		// is *not* over, so move on to the next player
		currentPlayer += 1
		if currentPlayer == PLAYERS {
			currentPlayer = 0
		}
	}
} while gameOver == false