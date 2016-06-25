//
//  OverlayViewController.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/24/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//

import UIKit

//MARK: - Selector Constant

// Syntax sugar adapted from https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.tlnwn8wwq
private extension Selector {
    static let showOverlay = #selector(OverlayViewController.showOverlay(_:sender:))
}

//MARK: - OverlaySegueSupporting Protocol Definition

public protocol OverlaySegueSupporting {
    func showOverlay(overlay: UIViewController, sender: AnyObject?)
}

//MARK: - OverlaySegue Definition

public class OverlaySegue: UIStoryboardSegue {
    
    public override func perform() {
        var responder : UIResponder = sourceViewController
        while true {
            if let aViewController = responder as? UIViewController,
                let target = aViewController.targetViewControllerForAction(.showOverlay, sender: self) {
                responder = target
            }
            
            if let supportsOverlay = responder as? OverlaySegueSupporting {
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

//MARK: - OverlayViewController Definition

public class OverlayViewController: UIViewController, OverlaySegueSupporting {

    public var animatorType: ContainerAnimator.Type = ContainerAnimator.self
    private var _animator: ContainerAnimator?
    public var animator: ContainerAnimator {
        get {
            if _animator == nil {
                _animator = animatorType.init(containerView: view)
            }
            
            guard let _animator = _animator else {
                fatalError("Property `animator` still nil after autoloader triggered.")
            }
            return _animator
        }
        set {
            if let oldValue = _animator,
                let contentView = oldValue.currentContentView {
                oldValue.transition(nil, animated: false)
                newValue.transition(contentView, animated: false)
            }
            _animator = newValue
        }
    }
    
    public private(set) var overlayedViewController: UIViewController?
    
    //MARK: - OverlaySegueSupporting Methods

    public func showOverlay(overlay: UIViewController, sender: AnyObject?) {
        presentOverlay(overlay, animated: true)
    }
    
    //MARK: - Overlay Actions
    
    public func presentOverlay(overlay: UIViewController, animated: Bool, completion: ((Bool)->Void)? = nil) {

        overlay.willMoveToParentViewController(self)
        addChildViewController(overlay)
        overlay.didMoveToParentViewController(self)
        
        animator.animationDirection = .Forward
        animator.transition(overlay.view, animated: true) { [weak self] (finished : Bool) in
            if let oldOverlay = self?.overlayedViewController {
                oldOverlay.willMoveToParentViewController(nil)
                oldOverlay.removeFromParentViewController()
                oldOverlay.didMoveToParentViewController(nil)
            }
            
            self?.overlayedViewController = overlay
        }
    }
    
    public func dismissOverlay(animated animated: Bool) {
        
        guard let overlayedViewController = overlayedViewController else {
            return
        }
        animator.animationDirection = .Reverse
        animator.transition(nil, animated: animated) { [weak self] (finished : Bool) in
            overlayedViewController.willMoveToParentViewController(nil)
            overlayedViewController.removeFromParentViewController()
            overlayedViewController.didMoveToParentViewController(nil)

            self?.overlayedViewController = nil
        }
    }
    
}
