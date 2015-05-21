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

//IN-OUT ARGS
func swapTwoInts(inout oneInt firstInt: Int, inout secondInt otherInt: Int) {
    let temp = firstInt
    firstInt = otherInt
    otherInt = temp
}

var oneInt = 8
var secondInt = 12
swapTwoInts(oneInt: &oneInt, secondInt: &secondInt)
println("oneInt is now \(oneInt), and secondInt is now \(secondInt)")


/*** CLOSURES **/

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


//constants and variables can contain almost any character, including unicode characters,
//but cannot contain whitespace chars, math symbols, arrows, and other

//if you need to give a constant or variable the same name as a reserved Swift keyword, 
//surround the keyword with back ticks (`) when using it as a name, but 
//avoid it, unless you have absolutely no choice.
    

/*** STRING INTERPOLATION 
Include name of a constant or variable as a placeholder in a longer
string and to prompt swift to replace it with the current value
of that constants or variable.
***/

var catName = "Garfield"

println("Our cat name is \(catName)")


/*** Type Aliases 
define an alternative name for an existing type. 
Type aliases are useful when you want to refer to an existing type
by a name that is contextually more appropiate, such as when working
with data of a specific size from an external source:
***/
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min


/**** TUPLES 
Tuples group multiple values into a single compound value. The values
within a tuple can be of any type and do not have to be of the same type
as each other.
You can create tuples from any permutation of types, and they can contain
as mani different types as you like.
***/

//you can decompose a tuple's content into separate constants or variables
//which you then access as usual
let (statusCode, statusMessage) = (404, "Not found")
println("The status code is \(statusCode) and status message is \(statusMessage)")

//to ignore some of the tuple's values, ifnore parts with an underscore (_)
let (justTheStatusCode, _) = (404, "Not found")

//Alternatively, access the individual element values in a tuple using
//index numbers starting at zero:
let http404Error = (404, "Not found")
println("The status code is \(http404Error.0) and status message is \(http404Error.1)")

//you can name the individual elements in a tuple when the tuple is defined
let http200Status = (statusCode: 200, description: "OK")
println("The status code is \(http200Status.statusCode) and status message is \(http200Status.description)")

//NOTE: tuples are useful for temporary groups of related values
//if your data structure is likely to persist beyond a temporary scope,
//model it as a clas or structure rather than a tuple.


/*** OPTIONALS ***/

let possibleNumber = "123"
let convertedNumber = possibleNumber.toInt()

let notANumber = "123sfsd"
let convertedNotANumber = notANumber.toInt() // this returns nil

//NOTE: nil cannot be used with nonoptional constants and variables,
//if a constant or variable needs to work with the absence of a value
//under certain conditions, always declare it as an optional value of
//the appropiate type.
var serverResponseCode: Int? = 404
serverResponseCode = nil

//if you define an optional var. without providing a default value,
//then the variable is automatically set to nil

//IMPORTANT! -> in Swift nil is not a pointer to a nonexistent object,
//(like in Obj. C), it is the absence of a value of a certain type.

/** forced unwrapping
once you're sure that the optional does contain a value, you can access
its underlying value by adding an exclamation mark (!) to the
end of the optional's name
**/

let optNumber: Int? = 204

if optNumber != nil {
    println("possibleNumber has an integer value of \(optNumber!)")
}
//if we would not control that the optional contains a value,
//then when trying to use ! to access a non-existent opt value
//triggers a runtime error.
        
/*** optional binding 
We use optional binding to find out whether an optional contains a value,
and if so, to make that value available as a temporary constant or 
variable. In this case there is not need to use the ! suffic to access
its value.
***/

if let actualNumber = possibleNumber.toInt() {
    println("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
} else {
    println("\'\(possibleNumber)\' could not be converted to an integer")
}

/*** implicitly unwrapped optionals
Somettimes, it is clear from a program's structure that an optional will
always have a value, after the value is first set. In these cases it is 
useful to remove the need to check and unwrap the optional's value
every time it is accessed, because it can be safely assumed to have
a value all of the time 
These kind of optionals are defined as implicitly unwrapped optionals.
They are written with an exclamation mark rather than a question mark.
**/
let possibleString: String? = "An optional string."
let forcedString: String = possibleString!

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString



/*** ASSERTIONS 
Optionals enable to check for values that may or may not exist.
In some cases, however, it is simply not possibe for your code
to continue execution if a value does not exist, or if a provided
value does not satisfy certain conditions --> trigger assertion in
the code to end code executions and provide an opportunity to debug
the case of the absent or invalid value.
***/

let age = -3
//assert(age >= 0, "A person's age cannot be less than zero")

//here age is not same or greater than zero, so the assertion is triggered,
//would terminate the application


/**** BASIC OPERATORS ****/

/**
-Unary -> !b, i++ ...
-Binary -> two targets -> 2 + 3
-Ternary -> a ? b : c
**/

//floating-point remainder calculations
8 % 2.5 // equals 0.5


/** Nil Coalescing Operator (a ?? b)
Unwraps an optional a if it contains a value, or returns a default b if a is nil.
**/
let defaultColorName = "red"
var userDefinedColorName : String?

var colorNameToUse = userDefinedColorName ?? defaultColorName



/** NOTES
-Swift's native String type is build from Unicode scalar values -> a unique 21-bite number for a char or modifier.
-Apart from the usual special chars as \0 \\ \t \n ... an arbitrary Unicode scalar written as \u{n}, where n is a 1-8 hexadecimal number with a value equal to a valid Unicode code point.
*/

let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665”



