// Playground - noun: a place where people can play

import UIKit

/**** constants definition ***/
let SWIFT_DEVS_PAGE_ID = "SwiftDevs"

enum SocialNetworkType {
    case Facebook
    case LinkedIn
    case GooglePlus
    case Pinterest
    case Instagram
    case Twitter
}

class SocialNetwork {
    let type: SocialNetworkType
    
    init(type: SocialNetworkType){
        self.type = type
    }
}

class SocialNetworkPage {
    let socialNetwork: SocialNetwork
    let pageId: String
    
    init(socialNetwork: SocialNetwork, pageId: String) {
        self.socialNetwork = socialNetwork
        self.pageId = pageId
    }
}

var socialNetworkPage = SocialNetworkPage(
    socialNetwork: SocialNetwork(type: .Twitter),
    pageId: SWIFT_DEVS_PAGE_ID
)

enum SpecialNumber: Double {
    //Special numbers aproxs. 
    //(enums do not allow to set as raw value an external constants like mathematical consts. starting with M_ ....)
    case Pi = 3.14159265358979
    case Phi = 1.618033988
    case Tau = 6.28318530717959
    case Euler = 2.71828182845905
}

//to access the raw value of each entry through the rawValue property
SpecialNumber.Pi.rawValue

//to create an enum member from a raw value
var specialNumber = SpecialNumber(rawValue: 3.14159265358979)



/***** ADVANCED FEATURES **********/
//enums can also have initializers, methods, computed properties and they can conform to protocols

/***
Associated Values --> 
-allow wach enum member to store data of any type
-associated values are assigned when the enum value is created and not when the enum is declared
***/

enum AccountTransactionResult {
    case Success(Float)
    case Error(String)
}

struct BankAccount {
    var currentBalance:Float = 10000.0
    
    let MAX_ACCOUNT_BALANCE:Float = 100000.0
    
    mutating func withdraw(amount:Float) -> AccountTransactionResult {
        if(amount <= self.currentBalance) {
            self.currentBalance -= amount
            return .Success(self.currentBalance)
        } else{
            return .Error("Not enough money!")
        }
    }
    
    mutating func add(amount:Float) -> AccountTransactionResult {
        //here we asume there is an upper bound balance limit and it is fixed to everybody. (although this seems to be far from most real situations)
        if(self.currentBalance + amount <= MAX_ACCOUNT_BALANCE){
            self.currentBalance += amount
            return .Success(self.currentBalance)
        } else{
            return .Error("Unabled to add such amount of money to your account, the account balance would be greater than your limit.")
        }
    }
}

extension BankAccount{
    init(initialBalance:Float) {
        self.currentBalance = initialBalance
    }
}


var myBankAccount = BankAccount(initialBalance: 15)
let withdrawResult = myBankAccount.withdraw(20)

switch withdrawResult {
case let .Success(newBalance):
    println("Your new balance is \(newBalance)")
case let .Error(errorMessage):
    println(errorMessage)
}


/***
Initializers and functions
***/

enum TaskStatus {
    case ReadyToStart
    case Executing(Int) //Int contains a taskID
    case Cancelled(Int)
    case Done(Int)
    
    init() {
        self = .ReadyToStart
    }
    
    //this function does nothing, it is just a sample
    func taskCanBeCancelled(taskId:Int) -> Bool {
        return true
    }
    
    mutating func cancelTask(taskId:Int) -> Bool {
        let canCancel = taskCanBeCancelled(taskId)
        if(canCancel){
            self = .Cancelled(taskId)
        }
        return canCancel
    }
}


/****** NOTES ******
*
-Enums values are not mapped to integers. The type of the enum values is the given type and
not Int.

-If we want that members are mapped to a value of another type, we can use enums with Raw values.

-Useful for:
*Error handling
*Build state machines
**/
