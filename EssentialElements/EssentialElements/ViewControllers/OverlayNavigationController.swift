//
//  OverlayNavigationController.swift
//  EssentialElements
//
//  Created by Holly Schilling on 6/27/16.
//  Copyright © 2016 Better Practice Solutions. All rights reserved.
//

import UIKit

public class OverlayNavigationController: UINavigationController, ShowOverlaySegueSupporting {

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
    
    public var activeOverlay: UIViewController?
    
    //MARK: - OverlaySegueSupporting Methods
    
    @objc public func showOverlay(overlay: UIViewController, sender: AnyObject?) {
        presentOverlay(overlay, animated: true, completion: nil)
    }
    
    public func presentOverlay(overlay: UIViewController, animated: Bool, completion: ((Bool)->Void)? = nil) {
        
        overlay.willMoveToParentViewController(self)
        addChildViewController(overlay)
        overlay.didMoveToParentViewController(self)
        
        animator.animationDirection = .Forward
        animator.transition(overlay.view, animated: true) { (finished : Bool) in
            if let oldOverlay = self.activeOverlay {
                oldOverlay.willMoveToParentViewController(nil)
                oldOverlay.removeFromParentViewController()
                oldOverlay.didMoveToParentViewController(nil)
            }
            
            self.activeOverlay = overlay
        }
    }
}
