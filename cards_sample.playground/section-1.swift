// Playground - noun: a place where people can play

import Foundation

/** RANK **/

enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
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
    
    func equals(rank: Rank) -> Bool {
        return rank.rawValue == self.rawValue
    }
}

/** SUIT **/

enum Suit: Int {
    case Spades = 1
    case Hearts, Diamonds, Clubs
    
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
    
    /** SUIT COLOR **/
    
    enum Color {
        case Black, Red
        
        func simpleDescription() -> String {
            switch self {
            case .Black:
                return "black"
            case .Red:
                return "red"
            }
        }
    }
    
    func color() -> Color {
        return (self == .Spades || self == .Clubs) ? Color.Black : Color.Red
    }
}


/** CARD **/

struct Card {
    var rank: Rank
    var suit: Suit
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}

/** CARD DECK **/

struct CardDeck {
    var cards: [Card]
    
    init(cards: [Card]){
        self.cards = cards
    }
    
    func show() {
        for card in cards {
            println("\(card.simpleDescription())")
        }
    }
}

/** CARD DECK FACTORY **/

class CardDeckFactory {
    
    private init(){}
    
    class func newDeck() -> CardDeck {
        var fullDeck = [Card]()
        
        for rankRawValue in Rank.Ace.rawValue...Rank.King.rawValue {
            for suit in [Suit.Spades, .Hearts, .Clubs, .Diamonds] {
                fullDeck.append(
                    Card(rank: Rank(rawValue: rankRawValue)!,
                        suit: suit)
                )
            }
        }
        
        return CardDeck(cards: fullDeck)
        
    }
}

let cardDeck = CardDeckFactory.newDeck()

cardDeck.show()
