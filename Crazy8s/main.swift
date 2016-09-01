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

#if DEBUG
	print("Creating a deck...")
#endif

var deck = createDeck()

#if DEBUG
	print("Deck size is \(deck.count)")
#endif

// From the MutableCollectionType extension
#if DEBUG
	print("Now shuffling the deck...")
#endif

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

// This is the card we're going to play, whether it's
// from the discard pile or from the deck
//
// We're getting the very first card from the deck that
// everyone will play on in the loop below
//
var currentCard = deck.removeFirst()

// We need to keep track of the suit separately from the played
// card because a player may play an 8 and declare a new suit,
// which the next player has to know about
var currentSuit = Suit.NoSuit

//
// And here begins the game
//
repeat {
	var turnOver = false

	//
	// Here begins a turn for a player
	//
	repeat {
		// Can the player use this card?
		#if os(Linux)
			var turn = players[currentPlayer].canPlayOn(deckCard: currentCard, orSuit: currentSuit)
		#else
			var turn = players[currentPlayer].canPlayOn(currentCard, orSuit: currentSuit)
		#endif

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

		if turn.successful {
			// The player has a card that they can put on the
			// discard pile!
			discardPile.append(turn.card!)

			// And the current card is what's on the top of the
			// discard pile
			currentCard = discardPile.last!

			// And set the suit we're telling the players to play
			currentSuit = turn.newSuit!

			// And the player's turn is over
			turnOver = true
		} else {
			// The player does not have a playable card, so
			// we need to pull the next card from the deck and
			// then let's see if that helps in the next round
			// of play
			players[currentPlayer].hand.append(deck.removeFirst())
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