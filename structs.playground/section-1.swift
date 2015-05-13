// Playground - noun: a place where people can play

import UIKit


/****************************** STRUCTS *************************************/

struct TodoItem {
    var title: String
    var content: String
    var dueDate: NSDate?
    //constant, once created a TodoItem, this string cannot be changed anymore
    let owner: String
}

var todoItem = TodoItem(
    title: "Get Milk",
    content: "really urgent!",
    dueDate: NSDate(),
    owner: "User1"
)

todoItem.title = "get 2 milk"

//if we want to create immutable instance of a struct, use let
let unchangeableTodoItem = TodoItem(
    title: "Get Milk",
    content: "Really urgent!",
    dueDate: NSDate(),
    owner: "New Title"
)



/***************** structs custom initializer ********/

struct TodoItem2 {
    var title: String
    var content: String
    var dueDate: NSDate?
    //constant, once created a TodoItem, this string cannot be changed anymore
    let owner: String
    
    init(owner:String) {
        self.owner = owner
        
        //it is mandatory to set a default value to all the properties
        //when using and initializer
        
        self.title = ""
        self.content = ""
    }
}

/***
*
When we implement a custom initializer, Swift no longer provides the default
memberwise initializer, in case we want to keep the memberwise intializer or simply
provide an additional initializer, add the initializer as an extension instead of adding it to the struct directly.
**/

extension TodoItem {
    init(owner:String) {
        self.owner = owner
        
        //it is mandatory to set a default value to all the properties
        //when using and initializer or setting the property as an optional parameter
        
        self.title = ""
        self.content = ""
    }
    
    /******************* STRUCT METHODS *************************/
    
    func summary() -> String {
        return "\(title) belongs to \(owner)"
    }
    
    //IMPORTANT!!!! by default instance methods of struct cannot modify instance
    //variables, to change this, we need to use mutating keyword
    
    mutating func makeDueToday() {
        self.dueDate = NSDate()
    }
}

todoItem.summary()
todoItem.makeDueToday()

/******** NOTES

Value types vs. reference types -> swift provides two fundamentally different types:
-value types
-reference types

....REFERENCES TYPES...

NSMutableArray *array1 = [@[@(5), @(8), @(2)] mutableCopy];
NSMutableArray *array2 = array1;
[array1 addObject:@(10)];
// array1: [5,8,2,10]
// array2: [5,8,2,10]

As we see, if we change the array object through either of these two variables, the same 
array object is modified

.....VALUE TYPES....

var array1 = [5,8,2]
var array2 = array1
array1.append(10)
// array1: [5,8,2,10]
// array2: [5,8,2]

When a value type is assigned to a variable, the variable always stores the value itself,
not a reference to a value. This means whenever a value is assigned to a new variable,
the new varaible gets its own copy of the value --> a value can always only have one owner.


-In Swift structs are value types and also arrays are implemented as structs.
That means they can only have one owner and are always copied when asssigned to a new variable
or sent to a method or function.

-BENEFITS OF USING VALUE TYPES (structs) --> code inherently safer, making changes to a struct
will not affect other parts of the program. For this reason most of the Swift standard libraries
use structs instead of classes.


-Classes are reference types.


****/






