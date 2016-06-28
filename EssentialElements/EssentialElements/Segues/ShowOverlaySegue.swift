//
//  ShowOverlaySegue.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/27/16.
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

//MARK: - Selector Constant

// Syntax sugar adapted from https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.tlnwn8wwq
private extension Selector {
    static let showOverlay = #selector(OverlayViewController.showOverlay(_:sender:))
}

//MARK: - ShowOverlaySegueSupporting Protocol Definition

public protocol ShowOverlaySegueSupporting : NSObjectProtocol {
    var animator: ContainerAnimator { get }
    var activeOverlay: UIViewController? { get set }
    
    func showOverlay(overlay: UIViewController, sender: AnyObject?)
    func presentOverlay(overlay: UIViewController, animated: Bool, completion: ((Bool)->Void)?)
    func dismissOverlay(animated animated: Bool)
}

extension ShowOverlaySegueSupporting {
    
    public func showOverlay(overlay: UIViewController, sender: AnyObject?) {
        presentOverlay(overlay, animated: true, completion: nil)
    }
    
    public func dismissOverlay(animated animated: Bool) {
        
        guard let activeOverlay = activeOverlay else {
            return
        }
        animator.animationDirection = .Reverse
        animator.transition(nil, animated: animated) { (finished : Bool) in
            activeOverlay.willMoveToParentViewController(nil)
            activeOverlay.removeFromParentViewController()
            activeOverlay.didMoveToParentViewController(nil)
            
            self.activeOverlay = nil
        }
    }
    
}

//MARK: - ShowOverlaySegue Definition

public class ShowOverlaySegue: UIStoryboardSegue {
    
    public override func perform() {
        var responder : UIResponder = sourceViewController
        while true {
            if let aViewController = responder as? UIViewController,
                let target = aViewController.targetViewControllerForAction(.showOverlay, sender: self) {
                responder = target
            }
            
            if let supportsOverlay = responder as? ShowOverlaySegueSupporting {
                supportsOverlay.showOverlay(destinationViewController, sender: self)
                break;
            }
            if let next = responder.nextResponder() {
                responder = next
            } else {
                fatalError("Could not find anything in UIResponder chain to handle action \(Selector.showOverlay)")
            }
        }
    }
}

//MARK: - UIViewController Extension

public extension UIViewController {
    
    public var overlayViewController : ShowOverlaySegueSupporting? {
        get {
            var viewController = self
            while true {
                if let viewController = viewController as? ShowOverlaySegueSupporting {
                    return viewController
                }
                if let next = viewController.parentViewController {
                    viewController = next
                } else {
                    return nil
                }
            }
        }
    }
}
