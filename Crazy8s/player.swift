import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class Player {
	var name: String = ""
	var hand: [Card] = []

	var scores: [Int: Int] = [:]
	var currentTurn = 0

	func canPlayOn(_ deckCard: Card, orSuit deckSuit: Suit) -> (successful: Bool, card: Card?, isEight: Bool?, newSuit: Suit?) {
		#if DEBUG
			print("---> \(self.name) gets \(deckCard.description) and suit \(deckSuit.simpleDescription()) (\(deckSuit.symbol()))")
		#endif

		var eightCount = 0
		var rankCount = 0
		var suitCount = 0

		// This map is for determining what our current distribution
		// of cards to suits is
		var suitDistribution: [Suit: Int] = [Suit.hearts: 0,
			Suit.spades: 0,
			Suit.diamonds: 0,
			Suit.clubs: 0]

		// And our hand, as a dictionary, with weights in terms of
		// optimal play
		var handWeights: [Card: Int] = [:]

		// The priority is to want to play the 8 and change the suit to the
		// one we have the most cards in, followed by playing the same rank,
		// then playing anything from the suit
		for card in hand {
			// Add to the suit distribution map
			suitDistribution.updateValue(suitDistribution[card.suit]! + 1, forKey: card.suit)

			var weight = 0

			// Now let's get the counts of what we have in our hand based on
			// the card from the deck
			if card.rank == Rank.eight {
				weight += 1000
				eightCount += 1
			} else if card.rank == deckCard.rank && deckCard.rank != Rank.eight {
				weight += 100
				rankCount += 1
			} else if card.suit == deckSuit {
				// If the deck card is an 8, then we want to bump up the suit weight
				// because we don't care to match on the rank, but rather we can play
				// any card in this suit
				if deckCard.rank == Rank.eight {
					weight += 500
				} else {
					weight += 10
				}

				suitCount += 1
			}

			handWeights[card] = weight
		}

		#if DEBUG
			print("\t----Dist for \(self.name)----")
			for (suit, count) in suitDistribution {
				print("\t\(suit.symbol()) - \(count)")
			}
			print("\t----Weights for \(self.name)----")
			for (card, weight) in handWeights {
				print("\t\(card.description) - \(weight)")
			}
		#endif

		// If all the counts are 0, then we didn't have a playable
		// card and we're done
		if eightCount == 0 && rankCount == 0 && suitCount == 0 {
			#if DEBUG
				print("No cards to play")
			#endif

			return (false, nil, false, Suit.noSuit)
		}

		// If we're here, then we have a valid card to play
		// so we want to sort the weight map and pick the card
		// with the most weight
		#if os(Linux)
			let sortedKeys = handWeights.sortedKeysByValue(isOrderedBefore: >)
		#else
			let sortedKeys = handWeights.sortedKeysByValue( >)
		#endif
		// Now get the top card
		let topCard = sortedKeys.first
		let topWeight = handWeights[topCard!]

		#if DEBUG
			print("Top Card is \(topCard!.description) with weight of \(topWeight!)")
		#endif

		var isEight = false
		var newSuit = Suit.noSuit
		// If the top card has a weight of 1000 or more, that's an 8
		// and we need to switch to another suit, preferably one where
		// we have a lot of cards to get rid of
		if topWeight >= 1000 {
			isEight = true
			// Yes, we have an 8, so let's see which suite is the most
			// represented in our hand
			#if os(Linux)
				let sortedSuitKeys = suitDistribution.sortedKeysByValue(isOrderedBefore: >)
			#else
				let sortedSuitKeys = suitDistribution.sortedKeysByValue( >)
			#endif

			// Now get the top suit
			newSuit = sortedSuitKeys.first!

			#if DEBUG
				print("Eight! We've picked \(newSuit.simpleDescription()) as the new suit")
			#endif
		} else {
			// We are not playing an 8, so the suit will be the same as the card,
			// but we need to keep the return tuple happy
			newSuit = topCard!.suit

			#if DEBUG
				print("\(self.name) is returning \(topCard!.description)")
			#endif
		}

		// And record the score for this turn
		currentTurn += 1
		scores[currentTurn] = topWeight

		// And we have to remove the card from our hand as we're giving it to the deck
		self.hand = self.hand.filter() { $0 != topCard }

		#if DEBUG
			print("\(self.name) has \(self.hand.count) cards")
			print("Returning \(topCard!.description)")
		#endif

		return (true, topCard, isEight, newSuit)
	}
}
