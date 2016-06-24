//
//  FunctionAnimation.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/24/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//

import UIKit

public class FunctionAnimation<ValueType : AnyObject> : CAKeyframeAnimation {

    // Function should expect values [0, 1]
    public var simpleValueFunction : ((Double) -> (ValueType))? {
        didSet {
            updateValues()
        }
    }
    
    public override var duration: CFTimeInterval {
        get {
            return super.duration
        }
        set {
            super.duration = newValue
            updateValues()
        }
    }
    
    public var frameRate : Double = 20 {
        didSet {
            updateValues()
        }
    }
    
    func updateValues() {
        guard let simpleValueFunction = simpleValueFunction else {
            keyTimes = nil
            values = nil
            return
        }
        
        let steps = Int(frameRate * duration)
        let stepSize = 1.0 / (steps + 1)
        
        var times = [Double]()
        var computedValues = [ValueType]()
        
        for stepIndex in 0..<steps {
            let aTime = stepSize * stepIndex
            let aValue = simpleValueFunction(aTime)
            times.append(aTime)
            computedValues.append(aValue)
        }
        
        keyTimes = times
        values = computedValues
    }
    
    public required override init() {
        super.init()
    }
    
    public convenience init(keyPath path: String?) {
        self.init()
        keyPath = path
    }

    
}
