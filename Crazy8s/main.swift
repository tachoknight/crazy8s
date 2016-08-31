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

