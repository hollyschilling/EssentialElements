//
//  UIView+FullSized.swift
//  EssentialElements
//
//  Created by Holly Schilling on 3/7/17.
//  Copyright © 2017 Better Practice Solutions. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func addFullSized(subview: UIView) {
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.frame = bounds
        addSubview(subview)
    }
}
