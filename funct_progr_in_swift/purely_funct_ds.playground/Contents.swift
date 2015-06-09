import Foundation

/*** Creating a binary search tree using Swift ***/

class Box<T> {
    let unbox: T    init(_ value: T) { self.unbox = value }
}

enum Tree<T> {
    case Leaf
    case Node(Box<Tree<T>>, Box<T>, Box<Tree<T>>)
}

let leaf: Tree<Int> = Tree.Leaf
let five: Tree<Int> = Tree.Node(Box(leaf), Box(5), Box(leaf))

func single<T>(x: T) -> Tree<T> {
    return Tree.Node(Box(Tree.Leaf), Box(x), Box(Tree.Leaf))
}

func count<T>(tree: Tree<T>) -> Int {
    switch tree {
        case let Tree.Leaf:
            return 0
        case let Tree.Node(left, x, right):
            return 1 + count(left.unbox) + count(right.unbox)
    }
}

func elements<T>(tree: Tree<T>) -> [T] {
    switch tree {
        case let Tree.Leaf:
            return []
        case let Tree.Node(left, x, right):
            return elements(left.unbox) + [x.unbox] + elements(right.unbox)
    }
}

func emptySet<T>() -> Tree<T> {
    return Tree.Leaf
}

func isEmptySet<T>(tree: Tree<T>) -> Bool {
    switch tree {
        case let Tree.Leaf:
            return true
        case let Tree.Node(_, _, _):
            return false
    }
}

func isBST<T: Comparable>(tree: Tree<T>) -> Bool {
    switch tree {
        case Tree.Leaf:
            return true
        case let Tree.Node(left, x, right):
            let leftElements = elements(left.unbox)
            let rightElements = elements(right.unbox)
            return all(leftElements) { y in y < x.unbox }
                && all(rightElements) { y in y > x.unbox }
                && isBST(left.unbox)
                && isBST(right.unbox)
    }
}

func setContains<T: Comparable>(x: T, tree: Tree<T>) -> Bool {
    switch tree {
        case Tree.Leaf:
            return false
        case let Tree.Node(left, y, right) where x == y.unbox:
            return true
        case let Tree.Node(left, y, right) where x < y.unbox:
            return setContains(x, left.unbox)
        case let Tree.Node(left, y, right) where x > y.unbox:
            return setContains(x, right.unbox)
        default:
            fatalError("The impossible occurred")
    }
}

func setInsert<T: Comparable>(x: T, tree: Tree<T>) -> Tree<T> {
    switch tree {
        case Tree.Leaf:
            return single(x)
        case let Tree.Node(left, y, right) where x == y.unbox:
            return tree
        case let Tree.Node(left, y, right) where x < y.unbox:
            return Tree.Node(Box(setInsert(x, left.unbox)), y, right)
        case let Tree.Node(left, y, right) where x > y.unbox:
            return Tree.Node(left, y, Box(setInsert(x, right.unbox)))
        default:
            fatalError("The impossible occurred")
    }
}

