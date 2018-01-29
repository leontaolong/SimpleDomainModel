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
            return Int((hourlyWage) * Double(hours))
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

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0

    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return self._job}
        set(value) {
            self._job = self.age > 15 ? value : nil
        }
    }

    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return self._spouse}
        set(value) {
            self._spouse = self.age >= 18 ? value: nil
        }
    }

    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    open func toString() -> String {
    var job = ""
    switch self._job?.type {
    case .Salary(let salary)?:
        job = "Salary\(String(describing: salary))"
    case .Hourly(let hourly)?:
        job = "Hourly\(hourly)"
    default:
        job = "nil"
    }

    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(job) spouse:\(String(describing: self._spouse?.firstName ?? nil))]"
    }
}

////////////////////////////////////
//Family

open class Family {
    fileprivate var members : [Person] = []

    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
        }
    }

    open func haveChild(_ child: Person) -> Bool {
        var haveChild = false
        self.members.forEach { (mem) in
            if(mem.age >= 21 && mem.spouse != nil){
                haveChild = true
            }
        }
        if haveChild {
            self.members.append(child)
        }
        return haveChild
    }

  open func householdIncome() -> Int {
    return self.members.reduce(0, { (result:Int, mem:Person) -> Int in
        if let income = mem.job?.calculateIncome(2000) {
            return result + income
        }
        return result
    })
  }
}




