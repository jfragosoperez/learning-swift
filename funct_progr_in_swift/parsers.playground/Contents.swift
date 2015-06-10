import Cocoa

/*** PARSER COMBINATORS 
Parsers are very useful tools, they take a list of tokens (usually, a list of chars) and transform it into a structure.
We tend to use parsers withing external tools like Bison or YACC.
Here will build a parser combinator library, which is a higher-order function that
thakes several parsers as input and returns a new parser as its output
The library will be based on a port of a Haskell library (2009)
We will use sequences and slices. We define a parser as a function that takes a slice of tokens
processes some of these tokens, and returns a tuple of the result and the remainder of the tokens.
**/


extension String {
    var characters: [Character] {
        var result: [Character] = []
        for c in self {
            result += [c]
        }
        return result
    }
    var slice: ArraySlice<Character> {
        let res = self.characters
        return res[0..<res.count]
    }
}

extension ArraySlice {
    var head: T? {
        return self.isEmpty ? nil : self[0]
    }
    
    var tail: ArraySlice<T> {
        if (self.isEmpty) {
            return self
        }
        return self[(self.startIndex+1)..<self.endIndex]
    }
    
    var decompose: (head: T, tail: ArraySlice<T>)? {
        return self.isEmpty ? nil
            : (self[self.startIndex], self.tail)
    }
}

extension Character: Printable {
    public var description: String {
        return "\"(self)\""
    }
}

func string(characters: [Character]) -> String {
    var s = ""
    s.extend(characters)
    return s
}

struct Parser<Token, Result> {
    let p: ArraySlice<Token> -> SequenceOf<(Result, ArraySlice<Token>)>
}

//get any character 
func parseCharacter(character: Character) -> Parser<Character, Character> {
    return Parser {
        x in if let(head, tail) = x.decompose {
            if head == character {
                return one((character, tail))
            }
        }
        return none()
    }
}

func none<A>() -> SequenceOf<A> {
    return SequenceOf(GeneratorOf { nil } )
}
func one<A>(x: A) -> SequenceOf<A> {
    return SequenceOf(GeneratorOfOne(x))
}

//we can abstract this method one final time, making it generic over any kind of token.
//Instead of checking if the token is equal, we pass in a function with type Token -> Bool
//and if the function returns true for the first char in the stream, we return it:
func satisfy<Token>(condition: Token -> Bool) -> Parser<Token, Token> {
    return Parser {
        x in if let(head, tail) = x.decompose {
            if condition(head) {
                return one((head, tail))
            }
        }
        return none()
    }
}

//now we can define a function token that works like parseCharacter, but can be used
//with any type that conforms to Equatable:

func token<Token: Equatable>(t: Token) -> Parser<Token, Token> {
    return satisfy { $0 == t }
}

//parsing a single symbol isn't very useful, unless we add functions to combine
//two parsers.
//the first function we introduce is choice operator, and it can parse using either the left
//operand or the right operand. It is implemented in a simple way: given an input string,
//it runs the left operand's parser, which yelds a sequence of possible results. Then it runs 
//the right operand, which also yields a sequence of possible resoluts, and it concatenates the two sequences.

infix operator <|> {associativity right precedence 130 }
func <|> <Token, A> (l: Parser<Token, A>, r: Parser<Token, A>) -> Parser<Token, A> {
    return Parser {
        input in l.p(input) + r.p(input)
    }
}




