//
//  FunctionAnimation.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/24/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

open class FunctionAnimation<ValueType : AnyObject> : CAKeyframeAnimation {

    // Function should expect values [0, 1]
    open var simpleValueFunction : ((Double) -> (ValueType))? {
        didSet {
            updateValues()
        }
    }
    
    open override var duration: CFTimeInterval {
        get {
            return super.duration
        }
        set {
            super.duration = newValue
            updateValues()
        }
    }
    
    open var frameRate : Double = 20 {
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
        
        keyTimes = times as [NSNumber]?
        values = computedValues
    }
    
    public required override init() {
        super.init()
    }
    
    public convenience init(keyPath path: String?) {
        self.init()
        keyPath = path
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
