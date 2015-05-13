// Playground - noun: a place where people can play

import UIKit

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

        