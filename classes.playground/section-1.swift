// Playground - noun: a place where people can play

import UIKit

/**
In contrast to structs, classes MUST define an iniatializer due to the fact
that they do not provide an initializer by default.
One way to solve this is to make the default initializer available setting
default values for all our properties.
***/

class User {
    var name: String = ""
    var alias: String = ""
    var age: Int = 0
    
    //another initializer 
    init(name: String, alias: String, age: Int) {
        self.name = name
        self.alias = alias
        self.age = age
    }
    
    //swift only provides the default initializer when we don't implement
    init(){}
    
    func sayHi() -> String {
        return "Hi \(name)"
    }
    
}


//MUTABILITY 
/** In contrast to struct instances that are based on value types, classes
use reference types. This means that when we use the let keyword, then only
the reference itself becomes immutable, but it is possible to change
values of the object that's currently referenced. E.g. : **/

let user1 = User(name: "User", alias: "Alias", age: 99)
user1.age = 20

//we cannot however assigna a new object to this variable:

let otherUser = User(name: "User", alias:"Alias", age: 99)
otherUser.age = 20

/** the following line would show in the compiler
//error: Cannot assign to 'let' value 'otherUser'
//because otherUser was just assigned to a reference **/

//otherUser = User(name: "User2", age: 10)



//INHERITANCE & INITIALIZERS

//subclass that adds one property and overrides the sayHi function

class SpecialUser : User {
    var greetingMessage: String
    
    init(name: String, alias: String, age: Int, greetingMessage: String) {
        self.greetingMessage = greetingMessage
        super.init(name: name, alias: alias, age: age)
    }

    override func sayHi() -> String {
        return "\(greetingMessage) \(name)"
    }
}


/**** INITIALIZERS ******/

/** REQUIRED INITIALIZERS 
Force subclasses to implement an initializer of their superclass
***/

class Car {
    var brandId: String = ""
    var modelName: String = ""
    
    required init (brandId: String, modelName: String) {
        self.brandId = brandId
        self.modelName = modelName
    }
    
}

class SuperCar : Car{
    
    required init (brandId: String, modelName: String) {
        super.init(brandId: brandId, modelName: modelName)
    }
    
}

/** CONVENIENCE INITIALIZERS 
Are not required to instantiate all properties of a class, instead they are allowed
to rely on other initializers. In swift only convenience initializers are allowed
to delegate initialization to other initializers.
***/

class Lamborghini : SuperCar {
    
    required init (brandId: String, modelName: String) {
        super.init(brandId: brandId, modelName: modelName)
    }
    
    //this allows Lamborghini to be initialized with a subset of the required
    //parameters. We do this using constructor chaining.
    convenience init(modelName: String){
        self.init(brandId: "123Sjk", modelName: modelName)
    }
    
    //NOTE: that it's unfortunately not possible to call convenience initializers
    //of a superclass, in my opinion that's a shortcoming of swift.
}

/**
DESIGNATED INITIALIZERS
All swift initializers are designed initializers by default, which means they are
required to fully initialize by assigning values to all non-optional properties.
If a calss is not a root class, designated initializer is also responsible for 
calling a designated initialier of the super class.

All initializers that do not have the convenience keyword are designated initializers. 
Required initializers are just a special form of designated initializer that need to 
be implemented by every subclass 
**/


/*** DEINITIALIZATION 
Luckily memory management in Swift works vastly automatically. Use cases for
deinitialization are rare. A typical one for iOS development is unsubscribing from
notifications. In Swift the deinitializer is called directly before the instance
is destroyed.
****/

/** Example from a class that subscribes to keyboard notifications
and unsibscribes as part of the deinitializer:
required init() {
    NSNotificationCenter.defaultCenter().addObserver(self,
        selector: "keyboardWillBeShown:",
        name: "UIKeyboardWillShowNotification",
        object: nil
    )
    
    NSNotificationCenter.defaultCenter().addObserver(self,
        selector: "keyboardWillBeHidden:",
        name: "UIKeyboardWillHideNotification",
        object: nil
    )
}

deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
}

**/








