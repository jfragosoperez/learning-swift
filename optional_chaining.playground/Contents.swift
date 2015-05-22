import Foundation

/*** OPTIONAL CHAINING
Optional chaining is a process for querying and calling properties, methods, and
subscripts on an optional that might currently be nil. If the optional contains a
value, the property, method or subscript call succeeds; else, call returns nil.
Mutiple queries can be chained together, and the entire chain fails gracefully
if any link in the chain is nil.
***/

/** Optional chaning as an alternative to forced unwrapping
**/

class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let john = Person()

//if we now try to access the numberOfRooms property to this person's residence,
//by placing an exclamation mark after residence to force the unwrapping of its value,
//we get a trigger runtime error because there is no residence value to unwrap


//solution:
if let roomCount = john.residence?.numberOfRooms {
    println("John's residence has \(roomCount) room(s).")
} else {
    println("Unable to retrieve the number of rooms")
}


/*** Defining model classes for optional chaining
We can use optional chainin with calls to props., methods, and subscripts that
are more than one level deep.
**/

class MoreComplexResidence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    var address: Address?
    
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        println("The number of rooms is \(numberOfRooms)")
    }
}

class Room {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil {
            return buildingNumber
        } else {
            return nil
        }
    }
}
