//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//

extension Double {
    var usd: Double {return self}
    var gbp: Double {return self * 2.0}
    var can: Double {return self * 0.8}
    var eur: Double {return self * 2 / 3.0}
}

public struct Money {
    public var amount : Int
    public var currency : String
    public var amountInUsd : Double
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
        switch currency {
        case "USD":
            self.amountInUsd = Double(amount).usd
        case "GBP":
            self.amountInUsd = Double(amount).gbp
        case "EUR":
            self.amountInUsd = Double(amount).eur
        case "CAN":
            self.amountInUsd = Double(amount).can
        default:
            self.amountInUsd = 0.0; self.amount = 0; self.currency = currency
        }
    }
  
    public func convert(_ to: String) -> Money {
        switch to {
        case "USD":
            return Money(amount: Int(amountInUsd), currency: to)
        case "GBP":
            return Money(amount: Int(amountInUsd / 1.gbp), currency: to)
        case "EUR":
            return Money(amount: Int(amountInUsd / 1.eur), currency: to)
        case "CAN":
            return Money(amount: Int(amountInUsd / 1.can), currency: to)
        default:
            return self
        }
    }
  
    public func add(_ to: Money) -> Money {
        let newAmount = (convert(to.currency)).amount + to.amount
        return Money(amount: newAmount, currency: to.currency)

    }
    
    public mutating func subtract(_ from: Money) -> Money {
        let newAmount = (convert(from.currency)).amount - from.amount
        return Money(amount: newAmount, currency: from.currency)
    }
}


////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType

    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }

    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }

    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let hourlyWage):
            return Int(hourlyWage) * hours
        case .Salary(let yearlySalary):
            return yearlySalary
        }
    }

    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let hourlyWage):
            self.type = JobType.Hourly(hourlyWage + amt)
        case .Salary(let yearlySalary):
            self.type = JobType.Salary(Int(Double(yearlySalary) + amt))
        }
    }
}

//////////////////////////////////////
//// Person
////
//open class Person {
//  open var firstName : String = ""
//  open var lastName : String = ""
//  open var age : Int = 0
//
//  fileprivate var _job : Job? = nil
//  open var job : Job? {
//    get { }
//    set(value) {
//    }
//  }
//
//  fileprivate var _spouse : Person? = nil
//  open var spouse : Person? {
//    get { }
//    set(value) {
//    }
//  }
//
//  public init(firstName : String, lastName: String, age : Int) {
//    self.firstName = firstName
//    self.lastName = lastName
//    self.age = age
//  }
//
//  open func toString() -> String {
//  }
//}
//
//////////////////////////////////////
//// Family
////
//open class Family {
//  fileprivate var members : [Person] = []
//
//  public init(spouse1: Person, spouse2: Person) {
//  }
//
//  open func haveChild(_ child: Person) -> Bool {
//  }
//
//  open func householdIncome() -> Int {
//  }
//}





