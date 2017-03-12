//
//  BorderedButton.swift
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

@IBDesignable
open class BorderedButton: UIButton {
    
    fileprivate static let TextColorKey = "textColor"
    
    //MARK: - Inspectable Properties
    
    @IBInspectable
    open var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        didSet {
            applyStyle()
        }
    }
    
    @IBInspectable
    open var normalColor: UIColor? {
        didSet {
            let image = normalColor.flatMap({ UIImage(color: $0) })
            setBackgroundImage(image, for: .normal)
        }
    }
    
    @IBInspectable
    open var disabledColor: UIColor? {
        didSet {
            let image = disabledColor.flatMap({ UIImage(color: $0) })
            setBackgroundImage(image, for: .disabled)
        }
    }
    
    @IBInspectable
    open var highlightedColor: UIColor? {
        didSet {
            let image = highlightedColor.flatMap({ UIImage(color: $0) })
            setBackgroundImage(image, for: .highlighted)
        }
    }
    
    @IBInspectable
    open var selectedColor: UIColor? {
        didSet {
            let image = selectedColor.flatMap({ UIImage(color: $0) })
            setBackgroundImage(image, for: .selected)
        }
    }
    
    @IBInspectable
    open var highlightedSelectedColor: UIColor? {
        didSet {
            let image = highlightedSelectedColor.flatMap({ UIImage(color: $0) })
            setBackgroundImage(image, for: [.highlighted, .selected])
        }
    }
    
    
    
    //MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
        
        #if !TARGET_INTERFACE_BUILDER
            addTitleColorChangeObserver()
        #endif
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
        
        #if !TARGET_INTERFACE_BUILDER
            addTitleColorChangeObserver()
        #endif
    }
    
    open override func prepareForInterfaceBuilder() {
        applyStyle()
    }
    
    deinit {
        #if !TARGET_INTERFACE_BUILDER
            titleLabel?.removeObserver(self, forKeyPath: BorderedButton.TextColorKey)
        #endif
    }
    
    //MARK: - Overrides
    
    open override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        super.setTitleColor(color, for: state)
        applyStyle()
    }
    
    //MARK: - KVO
    
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        // Accessing self.titleLabel triggers a recursion into this method, so we
        // can't explicitly check triggeringLabel==titleLabel
        guard let _ = object as? UILabel , BorderedButton.TextColorKey == keyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        applyStyle()
    }
    
    //MARK: - Private Helpers
    
    fileprivate func addTitleColorChangeObserver() {
        // titleLabel is nil for types other than System or Custom
        titleLabel?.addObserver(self,
                                forKeyPath: BorderedButton.TextColorKey,
                                options: [],
                                context: nil)
    }
    
    fileprivate func applyStyle() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        
        let color = borderColor ?? currentTitleColor
        layer.borderColor = color.cgColor
    }
    
    
}
