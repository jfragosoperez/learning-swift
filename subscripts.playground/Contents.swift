import Foundation

/** SUBSCRIPTS 
Classes, structures and enumerations can define subscripts, which are shortcuts for 
accessing the member elements of a collection, list or sequence.
You use subscripts to set and retrieve values by index without needing separate
methods for setting and retrieval, e.g. access elements in an Array instance as 
someArray[index] and elements in a Dictionary instance as someDictionary[key].
***/

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
println("six times three is \(threeTimesTable[6])")

//NOTE: 
//An n-times-table is based on a fixed mathematical rule. It is not appropiate to set
//threeTimesTable[someIndex] to a new value, and so the subscript for TimesTable is
//defined as a read-only subscript.



//another example: Matrix

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2

let someValue = matrix[2, 2]
//this triggers an assert, because [2, 2] is outside of the matrix bounds
