// Playground - noun: a place where people can play

import Foundation

/***
In variables and constants, it is not needed to declare explicitly its type, the compiler infers its type
***/

// variable declaration
var str = "Hello, playground"

// constant declaration
let constants = 32


/***
Just in case the initial value does not provide enough information (or if there is no initial value), specify the type **/

let explicitFloat: Float = 1.0


/*** Values are never implicitly converted to another type, to convert explicitly make an instance of the desired type.
***/

let label = "the widht is "
let width = 94
let widthLabel = label + String(width)

/*** Easiest way to include values in strings ***/

let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples"
let fruitSummary = "I have \(apples + oranges) pieces of fruit."


/*** create arrays and dictionaries using brackets ([]) and access elements by writing the index or key in brackets ***/

var shoppingList = ["catfish", "water", "tulips"]
shoppingList[1] = "bottle of water"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"


/*** to create an empty array or dictionary **/

let emptyArray = [String]()
let emptyDictionary = [String: Float]()

//if type can be inferred:

shoppingList = []
occupations = [:]


/*** Control flow ****/

let individualScores = [75,43,103]
var teamScore = 0

for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}

println(teamScore)


var firstForLoop = 0

//Use ..< to make a range that omits its upper value
for i in 0..<4 {
    firstForLoop += i
}
println(firstForLoop)

//Use ... to make a range that includes both values 

var secondForLoop = 0

for i in 0...4 {
    secondForLoop += i
}
println(secondForLoop)


/***** FUNCTIONS *****/

func averageOf(numbers: Float...) -> Float {
    var sum: Float = 0
    
    for number in numbers {
        sum += number
    }
    return numbers.capacity > 0 ? sum / Float(numbers.capacity) : 0
}
averageOf()
averageOf(42, 597, 12)


/**** NESTED FUNCTIONS 
Functions can be nested. Nested functions have access to variables that were declared
in the outer function. You can use nested functions to organize the code in a function that is long or complex.
******/

//Functions are a first-class type. This means that a function can return 
//another function as its value

func makeIncrementer() -> (Int -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)


//Functions can return multiple values

func getFirstNaturalNumbers() -> (first: Int, second: Int, third: Int) {
    return (1, 2, 3)
}


//you can write a closure without a name by surrounding code with braces ({}).
//Use in to separate the arguments and return type from the body.

var numbers = [20, 19, 7, 12]

numbers.map({
    (number: Int) -> Int in
    let result = number % 2 == 0 ? number : 0
    return result
})

//when a closure's type is already known, such as the callback for a delegate,
//you can omit the type of its parameters, its return type, or both:

let oddsConvertToZero = numbers.map({ number in number % 2 == 0 ? number : 0 })
println(oddsConvertToZero)

//we can refer to parameters by number instead of by name: useful in very short closures.
//A closure passed as the last argument to a function can appear immediately after the parentheses.

let sortedNumbersIncr = sorted(numbers)
let sortedNumbersDecr = sorted(numbers) { $0 > $1 }
println(sortedNumbersIncr)
println(sortedNumbersDecr)
    

class EquilateralTriangle {
    private var sideLength: Double = 0

    func getPerimeter() -> Double {
        return self.sideLength * 3
    }
    
    func setSideLength(sideLength: Double) {
        self.sideLength = sideLength
    }
}

var equilateralTriangle = EquilateralTriangle()
equilateralTriangle.setSideLength(2)
println(equilateralTriangle.getPerimeter())
    

/****
If you don’t need to compute the property but still need to provide code that is run before and after setting a new value, use willSet and didSet.
**/


/***
When working with optional values, you can write ? before operations like methods, 
properties, and subscripting. If the value before the ? is nil, everything after 
the ? is ignored and the value of the whole expression is nil. Otherwise, the 
optional value is unwrapped, and everything after the ? acts on the unwrapped 
value. In both cases, the value of the whole expression is an optional value.

let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength
**/
    
    

        
