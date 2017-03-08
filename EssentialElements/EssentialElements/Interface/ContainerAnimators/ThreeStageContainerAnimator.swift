//
//  ThreeStageContainerAnimator.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/28/16.
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

open class ThreeStageContainerAnimator : ContainerAnimator {
    
    open override func transition(_ newContentView: UIView?, animated: Bool, completion: ((Bool) -> Void)? = nil) {
     
        let enteringView = newContentView
        let leavingView = currentContentView
        
        func animations() {
            execute(enteringView, leavingView: leavingView)
        }
        
        func animationCompletion(_ finished : Bool) {
            finalize(enteringView, leavingView: leavingView)
            currentContentView = enteringView
            completion?(finished)
        }
        
        prepare(enteringView, leavingView: leavingView)
        UIView.animate(withDuration: animationDuration,
                                   delay: 0,
                                   options: animationOptions,
                                   animations: animations,
                                   completion: animationCompletion)
        
    }
    
    open func prepare(_ enteringView: UIView?, leavingView: UIView?) {
        
    }
    
    open func execute(_ enteringView: UIView?, leavingView: UIView?) {
        
    }

    open func finalize(_ enteringView: UIView?, leavingView: UIView?) {
        
    }
    
}
