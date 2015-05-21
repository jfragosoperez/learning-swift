import Foundation

/*** COLLECTION TYPES
Swift provides three primary collection types:
-Arrays -> ordered collections of values
-Sets -> unordered collections of distinct values
-Dictionaries -> unordered collections of key-value associations

These collections are mutable: we can add/remove/change items in the collection
after their creation.
If we want them to be immutable, we need to make them a constant and then
their size and contents cannot be changed.
**/

/*** ARRAYS 
Stores values of the same type in an ordered list. The same value can appear
in an array multiple times at different positions.
***/

let threeDoubes = [Double](count: 3, repeatedValue: 0.0)
let anotherThreeDoubles = [Double](count: 3, repeatedValue: 2.5)

let sixDoubles = threeDoubes + anotherThreeDoubles


var shoppingList = ["Eggs", "Milk"]
let numItemsShoppingList = shoppingList.count

if shoppingList.isEmpty {
    println("The shopping list is empty")
} else {
    println("The shopping list has \(shoppingList.count) items")
}

shoppingList.append("Flour")
shoppingList += ["Chocolate", "Cereals"]

var firstItem = shoppingList[0]

shoppingList[0] = "6 eggs"

//replace Milk and Flour with bananas and apples
shoppingList[1...2] = ["bananas", "apples"]
println(shoppingList)

//insert an item into the array at a specified index
shoppingList.insert("ice-cream", atIndex: 0)

//remove item at desired position
shoppingList.removeAtIndex(1)
println(shoppingList)

//to iterate use for in, and in case we need the integer index of each item
//as well as its value use the global enumerate function over the array
for (index, value) in enumerate(shoppingList) {
    println("Item \(index + 1): \(value)")
}


/*** SETS
Stores distinct values of the same type with no defined ordering.
***/

var letters = Set<Character>()
letters.insert("a")
println(letters)
letters.insert("a") //a char was inserted previously, so it is not inserted again

letters = [] //letters is now an empty set, but is still of type Set<Character> because type was just inferred

var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
favoriteGenres.insert("Jazz")

favoriteGenres.remove("Rock")
if favoriteGenres.contains("Classical") {
    favoriteGenres.remove("Classical")
}

favoriteGenres.insert("Blues")
favoriteGenres.insert("Swing")

//Swift's set type does not have a defined ordering. To iterate
//over the values of a set in a specific order, use the global
//sorte function, which returns an ordered collection of the 
//provided sequence

for genre in sorted(favoriteGenres) {
    println("\(genre)")
}

/** Constructing Sets **/

var firstCarBrandSet : Set<String> = ["Lamborghini", "Ferrari", "Bugatti"]
var secondCarBrandSet : Set<String> = ["Pagani", "Ferrari", "Lamborghini", "Ford"]

//new set with all the values in both sets
var union = firstCarBrandSet.union(secondCarBrandSet)

//new set with values not in the specified set
var substract = firstCarBrandSet.subtract(secondCarBrandSet)

//new set with only the values common to both sets
var intersection = firstCarBrandSet.intersect(secondCarBrandSet)

//new set with values in either set, but no both
var exclusion = firstCarBrandSet.exclusiveOr(secondCarBrandSet)


/*** Comparing Sets ***/

//equal operator (==)
println("sets are equal: \(firstCarBrandSet == secondCarBrandSet))")

//subset

var subset : Set<String> = ["abc", "bcd"]
var subsetCopy : Set<String> = ["abc", "bcd"]
var set : Set<String> = ["hey", "abc", "edf", "bcd"]
var setCopy : Set<String> = ["hey", "abc", "edf", "bcd"]
var anotherSet : Set<String> = ["zzzz", "bbbbb"]

println("set subset is a subset of set: \(subset.isSubsetOf(set))")

//superset

println("set set is a superset of subset: \(set.isSupersetOf(subset))")

//strict superset and strict subset

println("set subset is strict subset of subsetCopy: \(subset.isSubsetOf(subsetCopy))")
println("set subset is strict subset of subsetCopy: \(subset.isStrictSubsetOf(subsetCopy))")

println("set set is a superset of subset: \(set.isSupersetOf(setCopy))")
println("set set is a strict uperset of setCopy: \(set.isStrictSupersetOf(setCopy))")

//disjoint sets

println("set subset is disjoint with set set: \(subset.isDisjointWith(set))")
println("set anotherSet is disjoint with set set: \(anotherSet.isDisjointWith(set))")


/*** Hash values for set types 
A type must be hashable in order to be stored in a set- the type must provide a way to compute a hash value for itself.
Custom types as set value types or dictioary key types must conform the Hashable protocol from Swift's standard library.
Types that conform to the Hashable protocol must provide a gettable Int property called hashValue.
***/



/*** DICTIONARIES
Stores associations between keys of same type and values of the same type in a collection with no defined order.
Each value ia associated with a unique key, which acts as an identifier for that value within the dictionary.
Useful for look up values based on their id.
A dictionary must conform to the Hashable protocol, like a set's value type.
***/

var airports = ["YYZ": "Toronto Pearson",
    "DUB": "Dublin"]

//empty dictionary again, but keeps the key/values types
//that were inferred after initialization
airports = [:]
airports["BCN"] = "Barcelona"
airports["LHR"] = "London Heathrow"

//NOTE: again the dictionary has been declared with var 
//instead of let (constant) because we need this dict. to
//change its content

//dictionary has also count and isEmpty properties

//UPDATE
airports["BCN"] = "Barcelona El Prat"
//same as: (but also return old value after performing update)
airports.updateValue("Barcelona", forKey: "BCN")

//search and check if given key exists:

if let airportName = airports["DUB"] {
    println("The name of the airport is \(airportName)")
} else {
    println("That airport is not in the airports dict.")
}

//removal:

airports["BCN"] = nil

//or: (also returns the removed value)
airports.removeValueForKey("LHR")

//Iterating

airports = ["YYZ": "Toronto Pearson",
    "DUB": "Dublin"]

for (airportCode, airportName) in airports {
    println("\(airportCode): \(airportName)")
}

//iterate through keys
for airportCode in airports.keys {
    println("Airport code: \(airportCode)")
}

//iterate through values
for airportName in airports.values {
    println("Airport name: \(airportName)")
}

//if we need an array of the keys/values:
let airportCodes = [String](airports.keys)
let airportNames = [String](airports.values)
