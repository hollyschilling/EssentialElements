//
//  CrossFadeContainerAnimator.swift
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

public class CrossFadeContainerAnimator : ContainerAnimator {
    
    
    public func fadeViewIn(targetView : UIView) -> Void -> Void {
        return {
            targetView.alpha = 1
        }
    }
    
    public func fadeViewOut(targetView : UIView) -> Void -> Void {
        return {
            targetView.alpha = 0
        }
    }
    
    func phasedAnimation(view: UIView?, animated: Bool, animation: UIView -> Void -> Void, nextPhase: Bool -> Void) -> Bool -> Void {
        return { (finished) in
            guard let view = view else {
                nextPhase(finished)
                return
            }
            self.optionallyAnimate(animated,
                                   animation: animation(view),
                                   completion: nextPhase)
        }
    }

    func optionallyAnimate(animated: Bool, animation: Void -> Void, completion : (Bool -> Void)?) {
        
        if animated {
            UIView.animateWithDuration(animationDuration,
                                       delay: 0,
                                       options: animationOptions,
                                       animations: animation,
                                       completion: completion)
        } else {
            animation()
            completion?(false)
        }
    }
    
    public override func transition(newContentView: UIView?, animated: Bool, completion: ((Bool) -> Void)? = nil) {

        let oldContentView = currentContentView
        currentContentView = newContentView
        
        func allComplete(finished : Bool) {
            oldContentView?.removeFromSuperview()
            completion?(finished)
        }
        
        func combinedAnimation() {
            newContentView?.alpha = 1
            oldContentView?.alpha = 0
        }
        
        if let newContentView = newContentView {
            newContentView.frame = containerView.bounds
            newContentView.alpha = 0
            containerView.addSubview(newContentView)
        }
        
        if let newContentView = newContentView where !newContentView.opaque,
            let oldContentView = oldContentView where !oldContentView.opaque  {
            
            optionallyAnimate(animated,
                              animation: combinedAnimation,
                              completion: allComplete)
        } else {
            
            let phaseTwo = phasedAnimation(oldContentView,
                                           animated: animated,
                                           animation: fadeViewOut,
                                           nextPhase: allComplete)
            let phaseOne = phasedAnimation(newContentView,
                                           animated: animated,
                                           animation: fadeViewIn,
                                           nextPhase: phaseTwo)
            
            phaseOne(false)
        }
    }
    
}