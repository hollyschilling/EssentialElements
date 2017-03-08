//
//  ContainerAnimator.swift
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


open class ContainerAnimator {
    
    public enum AnimationDirection {
        case forward
        case reverse
    }
    
    open fileprivate(set) var containerView : UIView
    open weak var currentContentView : UIView?
    
    open var animationDuration : TimeInterval = 0.3
    open var animationOptions : UIViewAnimationOptions = .beginFromCurrentState
    open var animationDirection : AnimationDirection = .forward
    
    public required init(containerView aView : UIView) {
        containerView = aView
    }
    
    open func transition(_ newContentView: UIView?, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        
        if let oldContentView = currentContentView {
            oldContentView.removeFromSuperview()
        }
        
        if let newContentView = newContentView {
            newContentView.frame = containerView.bounds
            newContentView.translatesAutoresizingMaskIntoConstraints = true
            containerView.addSubview(newContentView)
            currentContentView = newContentView
        }
        
        completion?(true)
//        fatalError("Subclasses must implement \(#function) and not call super")
    }
    
}
