import Foundation

//
// For Linux:
// swiftc -DDEBUG card.swift extensions.swift main.swift player.swift
//

let PLAYERS = 4

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
let CARDCOUNT = 8
let ROUNDS = PLAYERS * CARDCOUNT

for idx in 1 ... ROUNDS {
}