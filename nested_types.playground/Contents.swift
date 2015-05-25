import Foundation

/*** NESTED TYPES 
It can be convenient to define utility classes and structures purely for use within the
context of a more complex type. 
**/

struct BlackjackCard {

    enum Suit: Character {
        case Spaces = "♠",
        Hearts = "♡",
        Diamonds = "♢",
        Clubs = "♣"
    }
    
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
        
        struct Values {
            let first: Int, second: Int?
        }
        
        var values: Values {
            switch self {
            case .Ace:
                return Values(first: 1, second: 11)
            case .Jack, .Queen, .King:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    let rank: Rank, suit: Suit
    
    var description: String {
        var output = "Suit is \(suit.rawValue),"
            output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

//To use a nested type outside of its definition context, prefix its name with the name 
//of the type it is nested within:

let heartsSymbol = BlackjackCard.Suit.Hearts.rawValue
