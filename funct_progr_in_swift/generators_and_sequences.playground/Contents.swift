import UIKit

//Conceptually a generator is a process that generates new array elements on request.
protocol GeneratorType {
    typealias Element
    func next() -> Element?
}

//producing array indices starting from the end of an array until it reaches 0
class CountdownGenerator: GeneratorType {
    typealias Element = Int
    
    var element: Element
    
    init<T>(array: [T]) {
        self.element = array.count - 1
    }
    
    func next() -> Element? {
        return self.element < 0 ? nil : element--
    }
}

//we can use this CountdownGenerator to traverse an array backward:
let xs = ["A", "B", "C"]

let generator = CountdownGenerator(array: xs)
while let i = generator.next() {
    println("Element \(i) of the array is \(xs[i])")
}

//the following generator produces a list of strings, corresponding to the lines of a file:
class FileLinesGenerator: GeneratorType {
    typealias Element = String
    
    var lines: [String]
    
    init(fileName: String) {
        if let contents = String(contentsOfFile: fileName, encoding: NSUTF8StringEncoding, error: nil) {
            let newLineChar = NSCharacterSet.newlineCharacterSet()
            lines = contents.componentsSeparatedByCharactersInSet(newLineChar)
        } else{
            lines = []
        }
    }
    
    func next() -> Element? {
        if let nextLine = lines.first {
            lines.removeAtIndex(0)
            return nextLine
        } else {
            return nil
        }
    }
}

//limit values from its argument generator:

class LimitGenerator<G: GeneratorType>: GeneratorType {
    typealias Element = G.Element
    var limit = 0
    var generator: G
    
    init(limit: Int, generator: G) {
        self.limit = limit
        self.generator = generator
    }
    
    func next() -> Element? {
        if limit >= 0 {
            limit--
            return generator.next()
        } else {
            return nil
        }
    }
}

//we can even define functions to manipulate and combine generators in terms of GeneratorOf
//here the generator simply reads off new elements from its first argument generator
//once this is exhausted, it produces elements from its second generator
func +<A>(var first: GeneratorOf<A>, var second: GeneratorOf<A>) -> GeneratorOf<A> {
    return GeneratorOf { first.next() ?? second.next() }
}


/*** SEQUENCES 
Generators form the basis of another Swift protocol, sequences. Generators provides a 
'one-shot' mechanism for repeatedly computing a next element. There is no way to rewind
or replay the elements generated. The only thing we can do is create a fresh generator and use
that instead. The SequenceType protocol provides just the right interface for doing that.
****/

protocol SequenceType {
    typealias Generator: GeneratorType
    func generate() -> Generator
}

//Every sequence has an associated generator type and a method to create a new generator

struct ReverseSequence<T>: SequenceType {
    var array: [T]
    
    init(array:[T]) {
        self.array = array
    }
    
    typealias Generator = CountdownGenerator
    
    func generate() -> Generator {
        return CountdownGenerator(array: array)
    }
}

//every time we want to traverse the array stored in the ReverseSequence struct, we can
//call the generate method to produce the desired generator. 

let reverseSequence = ReverseSequence(array: xs)
let reverseGenerator = reverseSequence.generate()

while let i = reverseGenerator.next() {
    println("Index \(i) is \(xs[i])")
}

//Swift has special syntax for working with sequences. Instead of creating the generator
//associated with a sequence yourself, you can write a for-in loop.

for i in ReverseSequence<String>(array: xs) {
    println("Index \(i) is \(xs[i])")
}

//there are also standard map and filter functions that manipulate sequences rather than arrays:
let reverseElements = map(ReverseSequence(array: xs)) { i in xs[i] }
for x in reverseElements {
    prinln("Element is \(x)")
}



