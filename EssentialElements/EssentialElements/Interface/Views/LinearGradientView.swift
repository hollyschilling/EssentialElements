//
//  LinearGradientView.swift
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
import CoreGraphics

@IBDesignable
open class LinearGradientView: UIView {
    
    public enum Position: Int {
        case topLeft = 7
        case topCenter = 0
        case topRight = 1
        case middleLeft = 6
        case middleRight = 2
        case bottomLeft = 5
        case bottomCenter = 4
        case bottomRight = 3
    }
    
    //MARK: - Public Properties
    
    @IBInspectable
    open var firstColor: UIColor = UIColor(white: 0.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable
    open var secondColor: UIColor = UIColor(white: 0.0, alpha: 0.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable
    open var startPositionValue: Int {
        get {
            return startPosition.rawValue
        }
        set {
            guard let position = Position(rawValue: newValue) else { return }
            startPosition = position
        }
    }
    
    open var startPosition: Position = Position.topCenter {
        didSet {
            updatePoints()
        }
    }
    
    open var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    //MARK: - Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        firstColor = aDecoder.decodeObject(of: [UIColor.self], forKey: "firstColor") as? UIColor ?? firstColor
        secondColor = aDecoder.decodeObject(of: [UIColor.self], forKey: "secondColor") as? UIColor ?? secondColor
        startPositionValue = aDecoder.decodeInteger(forKey: "startPositionValue")
    }
    
    private func commonSetup() -> Void {
        backgroundColor = UIColor.clear
        updateColors()
        updatePoints()
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(firstColor, forKey: "firstColor")
        aCoder.encode(secondColor, forKey: "secondColor")
        aCoder.encode(startPositionValue, forKey: "startPositionValue")
    }
    
    open override func prepareForInterfaceBuilder() {
        updateColors()
        updatePoints()
    }
    
    //MARK: - Private Helper properties
    
    private var startX: CGFloat {
        switch startPosition {
        case .topLeft, .middleLeft, .bottomLeft:
            return 0.0
        case .topCenter, .bottomCenter:
            return 0.5
        case .topRight, .middleRight, .bottomRight:
            return 1.0
        }
    }
    
    private var endX: CGFloat {
        return 1.0 - startX
    }
    
    private var startY: CGFloat {
        switch startPosition {
        case .topLeft, .topCenter, .topRight:
            return 0.0
        case .middleLeft, .middleRight:
            return 0.5
        case .bottomLeft, .bottomCenter, .bottomRight:
            return 1.0
        }
    }
    
    private var endY: CGFloat {
        return 1.0 - startY
    }
    
    //MARK: - Private Methods
    
    private func updateColors() {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
    }
    
    private func updatePoints() {
        gradientLayer.startPoint = CGPoint(x: startX, y: startY)
        gradientLayer.endPoint = CGPoint(x: endX, y: endY)
    }
    
}
