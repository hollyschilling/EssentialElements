//
//  DoubleOperations.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/24/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//

import Foundation

public func +(lhs : Double, rhs : Int) -> Double {
    return lhs + Double(rhs)
}

public func +(lhs : Int, rhs : Double) -> Double {
    return Double(lhs) + rhs
}

public func -(lhs : Double, rhs : Int) -> Double {
    return lhs - Double(rhs)
}

public func -(lhs : Int, rhs : Double) -> Double {
    return Double(lhs) - rhs
}

public func *(lhs : Double, rhs : Int) -> Double {
    return lhs * Double(rhs)
}

public func *(lhs : Int, rhs : Double) -> Double {
    return Double(lhs) * rhs
}

public func /(lhs : Double, rhs : Int) -> Double {
    return lhs / Double(rhs)
}

public func /(lhs : Int, rhs : Double) -> Double {
    return Double(lhs) / rhs
}

