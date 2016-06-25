//
//  ContainerAnimator.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/24/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//

import UIKit


public class ContainerAnimator {
    
    public enum AnimationDirection {
        case Forward
        case Reverse
    }
    
    public private(set) var containerView : UIView
    public private(set) weak var currentContentView : UIView?
    
    public var animationDuration : NSTimeInterval = 0.3
    public var animationOptions : UIViewAnimationOptions = [.BeginFromCurrentState, .CurveEaseInOut]
    public var animationDirection : AnimationDirection = .Forward
    
    public required init(containerView aView : UIView) {
        containerView = aView
    }
    
    public func transition(newContentView: UIView?, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        fatalError("Subclasses must implement \(#function) and not call super")
    }
    
}