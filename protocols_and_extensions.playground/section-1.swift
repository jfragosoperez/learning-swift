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


