import Foundation

func swapTwoValues<T>(inout a: T, inout b: T) {
    let tempA = a
    a = b
    b = tempA
}

var someInt = 3
var anotherInt = 100
swapTwoValues(&someInt, &anotherInt)

var oneString = "hello"
var anotherString = "world"
swapTwoValues(&oneString, &anotherString)



//Stack generic impl.

struct Stack<T> {
    var items = [T]()
    
    mutating func push(item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    func peek() -> T? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

var intStack = Stack<Int>()
intStack.push(1)
intStack.peek()
intStack.push(2)
intStack.push(3)
intStack.pop()
println(intStack.peek())

extension Stack {
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
}

intStack.isEmpty()



//Type constraints

func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {

    for (index, value) in enumerate(array) {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
