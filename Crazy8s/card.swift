
import Foundation

enum Suit: Int {
	case Hearts = 100
	case Spades = 200
	case Diamonds = 300
	case Clubs = 400
	case NoSuit = 0

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
		case .NoSuit:
			return "no suit"
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
		case .NoSuit:
			return "none"
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
		case .NoSuit:
			return "NS"
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

//
// The card struct/class that is what we're playing
// with
//
struct Card: Hashable, CustomStringConvertible {
	var rank: Rank
	var suit: Suit
	// For storing in dictionaries
	var hashValue: Int {
		return rank.rawValue + suit.rawValue
	}

	func simpleDescription() -> String {
		return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
	}

	// From CustomStringConvertable protocol
	var description: String {
		return "\(suit.symbol())\(rank.symbol())"
	}
}

// For the Card class' equatable protocol
func == (lhs: Card, rhs: Card) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

//
// Function for creating a deck of cards
//
func createDeck() -> [Card] {
	var n = 1
	var deck = [Card]()
	while let rank = Rank(rawValue: n) {
		var m = 100
		while let suit = Suit(rawValue: m) {
			deck.append(Card(rank: rank, suit: suit))
			m += 100
		}
		n += 1
	}
	return deck
}
