import Foundation

/** PROTOCOLS AND EXTENSIONS 
Classes, enumerationsn and structs can all adopt protocols.
**/

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    
    /**
    doesn't need to mark the method as mutating because methods on a class
    can always modify the class, contrary to structs/enums
    ***/
    func adjust() {
        simpleDescription += " Now 100% adjusted"
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription


struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    
    /***
    Note --> Use of the mutating keyword in the declaration of
    SimpleStructure to mark a method that modifies the structure
    **/
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}
var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription


enum SimpleEnum: ExampleProtocol {
    case Base, Adjusted
    
    var simpleDescription: String { get {return self.getDescription()} }
    
    func getDescription() -> String{
        switch self{
        case Base:
            return "A simple enum descr."
        case .Adjusted:
            return "A simple enum descr. (adjusted)"
        }
    }
    
    mutating func adjust() {
        self = .Adjusted
    }
}


/**** Use extension keyword to add functionality to an existing type,
such as new methods and computed properties. We can use an extension
to ass a propotocol conformance to a type that is declared elsewhere, 
or event to a type imported form a library or framework.
***/

extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    
    mutating func adjust() {
        self += 42
    }
}
var seven: Int = 7
println(seven.simpleDescription)
seven.adjust()
println(seven.simpleDescription)


protocol AbsoluteValueProtocol {
    typealias T: SignedNumberType
    var absoluteValue: T {get}
}

extension Double: AbsoluteValueProtocol {
    var absoluteValue: Double {
        return abs(self)
    }
    
    var other: Double {
        return self
    }
}
var myDouble: Double = -2.03
myDouble.absoluteValue



/*** GENERICS ***/

func repeat<Item>(item: Item, times: Int) -> [Item] {
    var result = [Item]()
    for i in 0..<times {
        result.append(item)
    }
    return result
}
repeat("knock", 4)


// you can make generic forms of functions and methods, as well as classes, 
// enumerations and structures

//Reimplement the Swift standard library's optional type
enum OptionalValue<T> {
    case None
    case Some(T)
}

var possibleInteger: OptionalValue<Int> = .None
possibleInteger = .Some(100)

//Use where after the type name to specify a list of requirements:

func anyCommonElements <T, U where T:
    SequenceType, U: SequenceType,
    T.Generator.Element: Equatable,
    T.Generator.Element == U.Generator.Element>(lhs: T, rhs: U) -> Bool {
        
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    return true
                }
            }
        }
        return false
}

anyCommonElements([1, 2, 3], [3])


func findCommonElements <T, U where T:
    SequenceType, U: SequenceType,
    T.Generator.Element: Equatable,
    T.Generator.Element == U.Generator.Element>(lhs: T, rhs: U) -> [T.Generator.Element] {
        
        var commonElems: [T.Generator.Element] = []
        
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    commonElems.append(lhsItem)
                }
            }
        }
        return commonElems
}

findCommonElements([1, 2, 3, 5, 4 ], [3, 1])


//RANDOM NUMBER GENERATOR

protocol RandomNumberGenerator {
    func random() -> Double
}

/*** Random number generator using pseudorandom number generator algorithm known as 
a linear congruential generator ***/

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c) % m)
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
println("Here's a random number: \(generator.random())")
println("And another one: \(generator.random())")


protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    
    mutating func toggle() {
        switch self {
        case Off:
            self = On
        case On:
            self = Off
        }
        
    }
}

var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()


/*** Delegation
Delegation is a design pattern that enables a class or structure to hand 
off (or delegate) some of its responisbilities to an instance of another type.
Delegation can be used to respond to a particular action or to retrieve data form
an external source without needing to know the underlying type of that source.
****/

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

protocol DiceGame {
    var  dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    
    init() {
        board = [Int](count: finalSquare + 1, repeatedValue: 0)
        board[03] = +08; board[06] = +11; board[09] = +09;
        board[10] = +02; board[14] = -10; board[19] = -11;
        board[22] = -02; board[24] = -08
    }
    
    var delegate: DiceGameDelegate?
    
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
            delegate?.gameDidEnd(self)
        }
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    
    func gameDidStart(game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            println("Started a new game of Snakes and Ladders")
        }
        println("The game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(gAME: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns++
        println("Roled a \(diceRoll)")
    }
    
    func gameDidEnd(game: DiceGame) {
        println("The game lasted for \(numberOfTurns)")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()


/**** PROTOCOL CONFORMANCE WITH AN EXTENSION ***/

protocol TextRepresentable {
    func asText() -> String
}

extension Dice: TextRepresentable {
    func asText() -> String {
        return "A \(sides)-sided dice"
    }
}

let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
println(d12.asText())

extension SnakesAndLadders: TextRepresentable {
    func asText() -> String {
        return "A game of snakes and ladders with \(finalSquare) squares"
    }
}
println(game.asText())


/*** PROTOCOL ADOPTION WITH AN EXTENSION ***/

struct Hamster {
    var name: String
    
    func asText() -> String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable{}

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster

println(somethingTextRepresentable.asText())


/*** Class-Only Protocols 
You can limit protocol adoption to class types (and not structures or enumerations)
by adding the class keyword to a protocol's inheritance list.
**/

protocol SomeInheritedProtocol {
    
}

protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol {
    
}

/*** PROTOCOL COMPOSITION ****/

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    println("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
}

let birthdayPerson = Person(name: "Malcom", age: 21)
wishHappyBirthday(birthdayPerson)



/*** OPTIONAL PROTOCOL REQUIREMENTS ****/

@objc protocol CounterDataSource {
    optional func incrementForCount(count: Int) -> Int
    optional var fixedIncrement: Int { get }
}

@objc class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    
    func increment() {
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}
