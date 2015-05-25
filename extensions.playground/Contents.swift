import Foundation

/** EXTENSIONS 
Extensions add new functionality to an existing class, structure or enumeration type.
This includes extending types for which we do not have access to the original code (this 
is called retroactive modeling).
Extensions can:
-Add computed properties and computed type properties
-Define instance methods and type methods
-Provide new initializers
-Define subscripts
-Make an existing type conform to a protocol

NOTE: Extensions can add functionality, but CANNOT OVERRIDE EXISTING FUNCTIONALITY **/

extension Double {
    var km: Double  { return self * 1_000.0 }
    var m:  Double  { return self           }
    var cm: Double  { return self / 100.0   }
    var mm: Double  { return self / 1_000.0 }
    var ft: Double  { return self / 3.28084 }
}

let oneInch = 25.4.mm
println("One inch is \(oneInch) meters")

let threeFeet = 3.ft
println("Three feet is \(threeFeet) meters")

//IMPORTANT: extensions can add new computed properties, but not store properties or add
//property observers to existing properties


//EXTENDING INITIALIZERS:

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}


//EXTENDING METHODS: 

extension Int {
    func repetitions(task: () -> ()) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions({
    println("Hello!")
})

3.repetitions { println("Goodbye!") }


//EXTENDING MUTATING INSTANCE METHODS
//Structure and enumerations methods that modify self or its properties must mark
//the instance method as mutating, just like mutating methods from an original
//implementation.

extension Int {
    mutating func square() {
        self = self * self
    }
}

var three = 3
three.square()


//EXTENDING SUBSCRIPTS

extension Int {
    subscript(var digitIndex: Int) -> Int {
        var decimalBase = 1
        while digitIndex > 0 {
            decimalBase *= 10
            --digitIndex
        }
        return (self / decimalBase) % 10
    }
}

746381295[0]
746381295[8]
746381295[2]


//NESTED TYPES

extension Int {
    enum Kind {
        case Negative, Zero, Positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}

func printIntegerKinds(numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .Negative:
            print("- ")
        case .Zero:
            print("0 ")
        case .Positive:
            print("+ ")
        }
    }
    print("\n")
}

printIntegerKinds([-9, 69, 0, 0, 0, 31, -24, -3, 2, -1, 0])