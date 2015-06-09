import Foundation

struct City {
    let name: String
    let population: Int
}

let paris = City(name: "Paris", population: 2243)
let amsterdam = City(name: "Amsterdam", population: 811)
let berlin = City(name: "Berlin", population: 3397)

let cities = [paris, amsterdam, berlin]


//we would like to print a list of cities with at least one million inhabitants,
//together with their total populations. 

//helper that scales up the inhabitants
func scale(city: City) -> City {
    return City(name: city.name, population: city.population * 1000)
}

cities.filter { city in city.population > 1000 }
    .map(scale)
    .reduce("City: Population") {
        result, c in return result + "\n" + "\(c.name): \(c.population)"
    }

//we start filtering out those cities that have less than one million inhabitants.
//we then map our scale function over the remaining cities. finally we compute
//a string with a list of city names and populations, using the reduce function.
