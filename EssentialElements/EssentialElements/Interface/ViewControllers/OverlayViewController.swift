//
//  OverlayViewController.swift
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

//MARK: - OverlayViewController Definition

public class OverlayViewController: UIViewController {

    public var animatorType: ContainerAnimator.Type = CrossFadeContainerAnimator.self
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
    
    //MARK: - Life Cycle
    
    public init(rootViewController : UIViewController) {
        super.init(nibName: nil, bundle: nil)
        willMove(toParentViewController: rootViewController)
        addChildViewController(rootViewController)
        didMove(toParentViewController: rootViewController)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
        if let child = childViewControllers.first {
            let childView = child.view!
            childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            childView.frame = view.bounds
            view.addSubview(childView)
        }
        
    }
    
    //MARK: - OverlaySegueSupporting Methods

    @objc public func show(overlay: UIViewController, sender: AnyObject?) {
        present(overlay: overlay, animated: true, completion: nil)
    }

    public func dismissOverlay(animated: Bool) {
        
        guard let activeOverlay = activeOverlay else {
            return
        }
        animator.animationDirection = .reverse
        animator.transition(nil, animated: animated) { (finished : Bool) in
            activeOverlay.willMove(toParentViewController: nil)
            activeOverlay.removeFromParentViewController()
            activeOverlay.didMove(toParentViewController: nil)
            
            self.activeOverlay = nil
        }
    }

    public func present(overlay: UIViewController, animated: Bool, completion: ((Bool)->Void)? = nil) {

        overlay.willMove(toParentViewController: self)
        addChildViewController(overlay)
        overlay.didMove(toParentViewController: self)
        
        animator.animationDirection = .forward
        animator.transition(overlay.view, animated: true) { (finished : Bool) in
            if let oldOverlay = self.activeOverlay {
                oldOverlay.willMove(toParentViewController: nil)
                oldOverlay.removeFromParentViewController()
                oldOverlay.didMove(toParentViewController: nil)
            }
            
            self.activeOverlay = overlay
        }
    }
}
