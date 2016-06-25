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
public class BorderedButton: UIButton {
    
    private static let TextColorKey = "textColor"

    //MARK: - Inspectable Properties
    
    @IBInspectable
    public var cornerRadius : CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    public var borderWidth : CGFloat = 2 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor : UIColor? {
        didSet {
            applyStyle()
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
    
    public override func prepareForInterfaceBuilder() {
        applyStyle()
    }
    
    deinit {
        #if !TARGET_INTERFACE_BUILDER
        titleLabel?.removeObserver(self, forKeyPath: BorderedButton.TextColorKey)
        #endif
    }
    
    //MARK: - Overrides
    
    public override func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(color, forState: state)
        applyStyle()
    }
    
    //MARK: - KVO
    
    public override func observeValueForKeyPath(keyPath: String?,
                                                ofObject object: AnyObject?,
                                                change: [String : AnyObject]?,
                                                context: UnsafeMutablePointer<Void>) {
        // Accessing self.titleLabel triggers a recursion into this method, so we 
        // can't explicitly check triggeringLabel==titleLabel
        guard let _ = object as? UILabel where BorderedButton.TextColorKey == keyPath else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        applyStyle()
    }
    
    //MARK: - Private Helpers
    
    private func addTitleColorChangeObserver() {
        // titleLabel is nil for types other than System or Custom
        titleLabel?.addObserver(self,
                                forKeyPath: BorderedButton.TextColorKey,
                                options: [],
                                context: nil)
    }
    
    private func applyStyle() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth

        let color = borderColor ?? currentTitleColor
        layer.borderColor = color.CGColor
    }
    
    
}
