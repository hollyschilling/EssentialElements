//
//  CGFloatOperations.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/24/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//

import Foundation

public func +(lhs : CGFloat, rhs : Int) -> CGFloat {
    return lhs + CGFloat(rhs)
}

public func +(lhs : Int, rhs : CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}

public func -(lhs : CGFloat, rhs : Int) -> CGFloat {
    return lhs - CGFloat(rhs)
}

public func -(lhs : Int, rhs : CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}

public func *(lhs : CGFloat, rhs : Int) -> CGFloat {
    return lhs * CGFloat(rhs)
}

public func *(lhs : Int, rhs : CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

public func /(lhs : CGFloat, rhs : Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}

public func /(lhs : Int, rhs : CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}
