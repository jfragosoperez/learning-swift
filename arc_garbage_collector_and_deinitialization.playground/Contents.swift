import Foundation

/*** DEINITIALIZATION 
Swift automatically deallocates instances when they are on longer needed, to free up
resources. Swift handles the memory management of instances through automatic reference
counting (ARC). Tipically you don't need to perform manual clean-up when instances
are deallocated. However, when you're working with your own resources, you might
need to perform some additional clean-up yourself, e.g. custom class to open a file
write some data to it, you might need to close the file before the class instance
is deallocated.

Deinitializers are called automatically, just before instance deallocation takes
place. You are not allowed to call a deinitializer yourself. Superclass deinitializers
are inherited by their subclasses, and the superclass deinitializer is called automatically
at the end of a subclass deinitializer implementation. Superclas deinitializer are 
always called independently of subclasses provide or not their own deinitializer.

Because an instance is not deallocated until after its deinitializer is called,
a deinitializer can access all properties of the instance it is called on and can
modify its behaviour based on those properties.
***/

struct Bank {
    static var coinsInBank = 10_000
    
    static func vendCoins(var numberOfCoinsToVend: Int) -> Int {
        numberOfCoinsToVend = min(numberOfCoinsToVend, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    
    static func receiveCoins(coins: Int) {
        coinsInBank += coins
    }
}

/*** The player class describes a player in the game.
Each player has a certain number of coins stored in their purse at any time. **/

class Player {
    var coinsInPurse: Int
    
    init(coins: Int) {
        self.coinsInPurse = Bank.vendCoins(coins)
    }
    
    func winCoins(coins: Int) {
        self.coinsInPurse += Bank.vendCoins(coins)
    }
    
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}

var playerOne: Player? = Player(coins: 100)
println("A new player has joined the game with \(playerOne!.coinsInPurse) coins")

println("There are now \(Bank.coinsInBank) coins left in the bank")

playerOne!.winCoins(2_000)
println("PlayerOne won 2000 coins and now has \(playerOne!.coinsInPurse) coins")

println("The bank now only has \(Bank.coinsInBank) coins left")


//let's suppose the player has now left the game -> playerOne = nil
//at this time the Player instance is broken. No other peroperties
//or variables are still referring to the Player instance, and so it
//is deallocated in order to free up its memory. Just before this
//happens, its deinitializer is called automatically and its coins
//are returned to the bank.

playerOne = nil
println("Player one has left the game")
println("The bank now has  \(Bank.coinsInBank) coins")


/**** ARC
Remember: Reference counting only applies to instances of classes. Structures
and enumerations are value types, not reference types, and are not
stored and passed by reference.
**/

/** ARC BEHAVIOUR 
If ARC were to deallocate an instance that was still in use, it would
no longer be possible to access that instance's properties, or call that
instance's methods. Indeed, if you tried to access the instance, the app
would most likely crash.

To make sure that instance don't disappear while they are still needed, 
ARC tracks how many properties, constants, and variables are currently 
referring to each class instance. ARC will not deallocate an instance 
as long as at least one active reference to that instance still exists.

To make this possible, whenever you assign a class instance to a property,
constant or variable, that prop., constant or var. makes a strong
reference to the instance. The reference is called a "strong" reference
because it keeps a firm hold on that instance, and does not allow it to be
deallocated for as long as that strong reference remains.

This means that if we assign one instance of a class to two more variables,
two more strong references of that instance are established,
and till the three references are not null, the ARC won't deallocate
the initial instance.
***/



/*** Strong reference cycles between class instances 
It is possible to write code in which an instance of a class never 
gets to a point where it has zero strong references. This can happen
if two class instances hold a strong reference to each other,
such that each instance keeps the other alive. This is known as
a strong reference cycle.

To resolve strong reference cycles we need to define some of the
relationships between classes as weak or unowned references instead
of as strong references.
**/

//example:

class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
    
    var apartment: Apartment?
    deinit {
        println("\(name) is being deinitialized")
    }
}

class Apartment {
    let number: Int
    var tenant: Person?
    
    init(number: Int) {
        self.number = number
    }
    
    deinit {
        println("Apartment #\(number) is being deinitialized")
    }
}

var john: Person?
var number73: Apartment?

john = Person(name: "John Appleseed")
number73 = Apartment(number: 73)

//let's do these two instances are related together and creating
//a strong reference cycle between them.
john!.apartment = number73
number73!.tenant = john!

//The person instance now has a strong reference to the Apartment instance
//and the Apartment instance has a strong reference to the Person
//instance. Therefore, when you break the strong references held
//by the john and number73 vars, the reference counts do not drop to
//zero, and the instance are not deallocated by ARC.

//if we try to cut down the references:
john = nil
number73 = nil
//neither deinitializer was called. The strong reference cycle prevents
//the two instance from ever being deallocated, causing a memory
//leak in your app.


/** Solution to strong reference cycles between class instances:
weak references and unowned references.

1-use a weak reference whenever it is valid for that reference to become
nil at some point during its lifetime.

2-use unowned reference when you know that reference will never be nil
once it has been set during initialization.
**/

/** Weak references --> reference that does not keep a strong hold
on the instance it refers to, and so does not stop ARC from
disposing of the referenced instance. 
Use a weak reference to avoid refreence cycles whenever it is possible 
for that reference to have "no value" at some point in its life.
Exampe: an apartment is able to have "no tenant" at some point in its
lifetime, and so a weak reference is an appropiate way to break the 
reference cycle in this case **/

//now let's redo our problem taking into account this change:

class Person2 {
    let name: String
    init(name: String) {
        self.name = name
    }
    
    var apartment: ApartmentWithWeakReferenceToTenant?
    deinit {
        println("\(name) is being deinitialized")
    }
}


class ApartmentWithWeakReferenceToTenant {
    let number: Int
    init(number: Int) {
        self.number = number
    }
    
    weak var tenant: Person2?
    
    deinit {
        println("Apartment #\(number) is being deinitialized")
    }
}

var oneTenant : Person2?
var number73WithWeakReferenceToTenant: ApartmentWithWeakReferenceToTenant?

oneTenant = Person2(name: "Hans")
number73WithWeakReferenceToTenant = ApartmentWithWeakReferenceToTenant(number: 73)

//let's do these two instances are related together and creating
//a strong reference cycle between them.
oneTenant!.apartment = number73WithWeakReferenceToTenant
number73WithWeakReferenceToTenant!.tenant = oneTenant

oneTenant = nil

//because there are no more strong references to the Person instance,
//it is deallocated
//The only remaining strong reference to the Apartment instance is from
//the number73WithWeakReferenceToTenant variable.
//If we break that reference, there are no more strong references
//to the Apartment instance:

number73WithWeakReferenceToTenant = nil
//because there are no more strong reference to the apartment instance 
//it too is deallocated.



