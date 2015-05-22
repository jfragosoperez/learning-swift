import Foundation

/*** TYPE CASTING
Way to check the type of an instance, and/or treat that instance as if it is a different
supperclass or subclass from somewhere else in its own class hierarchy.
***/

class Gadget {
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
}

class Laptop: Gadget {
    let osName: String
    
    init(modelName: String, osName: String) {
        self.osName = osName
        super.init(modelName: modelName)
    }
}

class Pointer: Gadget {
    let color: String
    
    init(modelName: String, color: String) {
        self.color = color
        super.init(modelName: modelName)
    }
}

let gadgets = [
    Laptop(modelName: "Macbook 13' late 2013", osName: "MacOSX Yosemite"),
    Pointer(modelName: "Logitech R400", color: "black"),
    Laptop(modelName: "HP ....", osName: "Windows 8"),
    Laptop(modelName: "Lenovo Thinkpad X1 CARBON", osName: "openSUSE")
]

var laptopCounter = 0
var pointerCounter = 0

for gadget in gadgets {
    if gadget is Laptop {
        laptopCounter++
    } else if gadget is Pointer {
        pointerCounter++
    }
}

println("Gadget library contains \(laptopCounter) laptops and \(pointerCounter) pointers")


/** Downcasting ***/

for gadget in gadgets {
    if let laptop = gadget as? Laptop {
        println("Laptop: '\(laptop.modelName)', OS. \(laptop.osName)")
    } else if let pointer = gadget as? Pointer {
        println("Pointer: '\(pointer.modelName)', color. \(pointer.color)")
    }
}


/*** Type casting for any and anyobject
Swift provides two special type aliases for working with non-specific types:
-AnyObject -> can represent an instance of any class type.
-Any -> can represent an instance of any type at all, including function types.
***/

/*** AnyObject ***/

let someObjects: [AnyObject] = [
    Laptop(modelName: "Macbook 13' late 2013", osName: "MacOSX Yosemite"),
    Laptop(modelName: "HP ....", osName: "Windows 8"),
    Laptop(modelName: "Lenovo Thinkpad X1 CARBON", osName: "openSUSE")
]


for object in someObjects {
    let laptop = object as! Laptop
    println("Laptop: '\(laptop.modelName)', OS. \(laptop.osName)")
}

//if we know that all items share same type:
for laptop in someObjects as! [Laptop] {
    println("Laptop: '\(laptop.modelName)', OS. \(laptop.osName)")
}


/** Any **/

var things = [Any]()

things.append(9)
things.append("a string")
things.append(Laptop(modelName: "Macbook 13' late 2013", osName: "MacOSX Yosemite"))

for thing in things {
    switch thing {
    case let someInt as Int:
        println("found integer with value of \(someInt)")
    case let aString as String:
        println("found string with value of \(aString)")
    case let laptop as Laptop:
        println("Laptop: '\(laptop.modelName)', OS. \(laptop.osName)")
    default:
        println("something else")
    }
}

//NOTE: the cases of a switch statement use the forced version of the type cast operator
//(as, not as?) to check and cast to a specific type. This check is always safe within
//the context of a switch case statement.
