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
    static let showOverlay = #selector(OverlayViewController.show(overlay:sender:))
}

//MARK: - ShowOverlaySegue Definition

open class ShowOverlaySegue: UIStoryboardSegue {
    
    open override func perform() {
        var responder : UIResponder = source
        while true {
            if let aViewController = responder as? UIViewController,
                let target = aViewController.targetViewController(forAction: .showOverlay, sender: self) {
                responder = target
            }
            
            if let ovc = responder as? OverlayViewController {
                ovc.show(overlay: destination, sender: self)
                break;
            }
            if let next = responder.next {
                responder = next
            } else {
                fatalError("Could not find anything in UIResponder chain to handle action \(Selector.showOverlay)")
            }
        }
    }
}

//MARK: - UIViewController Extension

public extension UIViewController {
    
    public var overlayViewController : OverlayViewController? {
        get {
            var viewController = self
            while true {
                if let viewController = viewController as? OverlayViewController {
                    return viewController
                }
                if let next = viewController.parent {
                    viewController = next
                } else {
                    return nil
                }
            }
        }
    }
}
