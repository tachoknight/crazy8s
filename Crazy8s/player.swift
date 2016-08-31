import Foundation

class Player {
	var name: String = ""
	var hand: [Card] = []

	var scores: [Int: Int] = [:]
	var currentTurn = 0

	func canPlayOn(deckCard: Card) -> (successful: Bool, card: Card?, isEight: Bool?, newSuit: Suit?) {

		// Need to create a score and play the card that has the best
		// score
		var score = 0

		var eightCount = 0
		var rankCount = 0
		var suitCount = 0

		// This map is for determining what our current distribution
		// of cards to suits is
		var suitDistribution: [Suit: Int] = [Suit.Hearts: 0,
			Suit.Spades: 0,
			Suit.Diamonds: 0,
			Suit.Clubs: 0]

		// And our hand, as a dictionary, with weights in terms of
		// optimal play
		var handWeights: [Card: Int] = [:]

		// The priority is to want to play the 8 and change the suit to the
		// one we have the most cards in, followed by playing the same rank,
		// then playing anything from the suit
		for card in hand {
			// Add to the suit distribution map
			suitDistribution.updateValue(suitDistribution[deckCard.suit]! + 1, forKey: deckCard.suit)

			// Now let's get the counts of what we have in our hand based on
			// the card from the deck
			if card.rank == Rank.Eight {
				eightCount += 1
			} else if card.rank == deckCard.rank {
				rankCount += 1
			} else if card.suit == deckCard.suit {
				suitCount += 1
			}
		}

		#if DEBUG
			print("----Dist for \(self.name)----")
			for (suit, count) in suitDistribution {
				print("\t\(suit.symbol()) - \(count)")
			}
			print("--------")
		#endif

		// If all the counts are 0, then we didn't have a playable
		// card and we're done
		if eightCount == 0 && rankCount == 0 && suitCount == 0 {
			return (false, nil, false, Suit.NoSuit)
		}

		// If we're here, then we have a valid card to play

		// And record the score for this turn
		currentTurn += 1
		scores[currentTurn] = score

		return (false, nil, false, Suit.NoSuit)
	}
}