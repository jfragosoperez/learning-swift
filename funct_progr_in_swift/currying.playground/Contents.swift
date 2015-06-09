import Foundation

/*** CURRYING
We can always transform a function that expects multiple arguments into a series of functions that each expect one argument (process named after the logician Haskell Curry)
***********/

//func without currying

func add1(x: Int, y: Int) -> Int {
    return x + y
}

//call: 
add1(2, 9)


//same func. currying

func add2(x: Int) -> (Int -> Int) {
    return { y in return x + y }
}

func add3(x: Int)(_ y: Int) -> Int {
    return x + y
}

//call:
add2(2)(9)
add3(2)(9)

//currying is great for composition, the good thing is that we have the choice to
//apply one single arg. or two args.
