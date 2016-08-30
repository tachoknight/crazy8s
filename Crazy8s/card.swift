
import Foundation

enum Suit: Int {
	case Hearts = 1
	case Spades
	case Diamonds
	case Clubs

	func simpleDescription() -> String {
		switch self {
		case .Spades:
			return "spades"
		case .Hearts:
			return "hearts"
		case .Diamonds:
			return "diamonds"
		case .Clubs:
			return "clubs"
		}
	}

	func color() -> String {
		switch self {
		case .Spades:
			return "black"
		case .Clubs:
			return "black"
		case .Diamonds:
			return "red"
		case .Hearts:
			return "red"
		}
	}

	func symbol() -> String {
		switch self {
		case .Spades:
			return "♠"
		case .Clubs:
			return "♣"
		case .Diamonds:
			return "♦"
		case .Hearts:
			return "♥"
		}
	}
}

enum Rank: Int {
	case Ace = 1
	case Two
	case Three
	case Four
	case Five
	case Six
	case Seven
	case Eight
	case Nine
	case Ten
	case Jack
	case Queen
	case King

	func simpleDescription() -> String {
		switch self {
		case .Ace:
			return "ace"
		case .Jack:
			return "jack"
		case .Queen:
			return "queen"
		case .King:
			return "king"
		default:
			return String(self.rawValue)
		}
	}

	func symbol() -> String {
		switch self {
		case .Ace:
			return "A"
		case .Jack:
			return "J"
		case .Queen:
			return "Q"
		case .King:
			return "K"
		default:
			return String(self.rawValue)
		}
	}
}

struct Card: CustomStringConvertible {
	var rank: Rank
	var suit: Suit

	func simpleDescription() -> String {
		return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
	}

	// From CustomStringConvertable protocol
	var description: String {
		return "\(suit.symbol())\(rank.symbol())"
	}
}

func createDeck() -> [Card] {
	var n = 1
	var deck = [Card]()
	while let rank = Rank(rawValue: n) {
		var m = 1
		while let suit = Suit(rawValue: m) {
			deck.append(Card(rank: rank, suit: suit))
			m += 1
		}
		n += 1
	}
	return deck
}
