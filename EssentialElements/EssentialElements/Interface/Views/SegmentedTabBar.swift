//
//  SegmentedTabBar.swift
//  EssentialElements
//
//  Created by Holly Schilling on 3/11/17.
//  Copyright © 2017 Better Practice Solutions. All rights reserved.
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

import Foundation
import UIKit

public protocol SegmentedTabBarDelegate: AnyObject {
    func numberOfIndexes(in tabBar: SegmentedTabBar) -> Int
    
    func button(for index: Int, in tabBar: SegmentedTabBar) -> UIButton
    func shouldSelect(index: Int?, in tabBar: SegmentedTabBar) -> Bool
    func didSelect(index: Int?, in tabBar: SegmentedTabBar)
}

extension SegmentedTabBarDelegate {
    
    public func shouldSelect(index: Int?, in tabBar: SegmentedTabBar) -> Bool {
        return true
    }
    
    public func didSelect(index: Int?, in tabBar: SegmentedTabBar) {
        // Do Nothing
    }
}

open class SegmentedTabBar: UIView {
    
    open weak var delegate: SegmentedTabBarDelegate? {
        didSet {
            reloadData()
        }
    }
    
    open private(set) var stackView: UIStackView = UIStackView(frame: CGRect.zero)
    
    open private(set) var buttons: [UIButton] = []
    
    private var _selectedIndex : Int?
    open var selectedIndex : Int? {
        get {
            return _selectedIndex
        }
        set {
            guard newValue != _selectedIndex else {
                return
            }
            
            guard newValue == nil || (newValue! < buttons.count && newValue! >= 0) else {
                print("New selectedIndex value out of range. (Failed 0 <= \(newValue!) < \(buttons.count))")
                return
            }
            
            if delegate?.shouldSelect(index: newValue, in: self) == false {
                return
            }
            
            if let oldValue = _selectedIndex, oldValue < buttons.count {
                buttons[oldValue].isSelected = false
            }
            
            if let newValue = newValue {
                buttons[newValue].isSelected = true
            }
            delegate?.didSelect(index: newValue, in: self)
        }
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.backgroundColor = UIColor.clear
        addFullSized(subview: stackView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stackView.backgroundColor = UIColor.clear
        addFullSized(subview: stackView)
    }
    
    open func reloadData() {
        _selectedIndex = nil
        
        for aButton in buttons {
            aButton.removeFromSuperview()
            aButton.removeTarget(self,
                                 action: #selector(SegmentedTabBar.segmentButtonTouched(sender:)),
                                 for: UIControlEvents.primaryActionTriggered)
        }
        
        guard let delegate = delegate else {
            return
        }
        
        var createdButtons = [UIButton]()
        
        let buttonCount = delegate.numberOfIndexes(in: self)
        for index in 0..<buttonCount {
            let aButton: UIButton = delegate.button(for: index, in: self)
            aButton.isSelected = (selectedIndex == index)
            stackView.addArrangedSubview(aButton)
            createdButtons.append(aButton)
        }
        buttons = createdButtons
    }
    
    open func segmentButtonTouched(sender : UIButton) {
        guard let senderIndex = buttons.index(of: sender) else {
            return
        }
        
        selectedIndex = senderIndex
    }
}

