import Foundation

class Player {
	var name: String = ""
	var hand: [Card] = []

	func canPlayOn(deckCard: Card) -> (successful: Bool, card: Card?) {

		return (false, nil)
	}
}