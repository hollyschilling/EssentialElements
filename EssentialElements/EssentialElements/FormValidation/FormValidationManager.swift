//
//  FormValidationManager.swift
//  EssentialElements
//
//  Created by Holly Schilling on 2/27/17.
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

open class FormValidationManager {
    
    public enum OverallAction {
        case allValidate
        case someFailures(Set<UITextField>)
        case successAction
    }
    
    // BlockTimer will retain itself while active
    // We keep it weak so it will automatically clear the reference
    private weak var validateTimer : BlockTimer?
    
    open var delay: TimeInterval = 1
    
    public let overallBlock: (OverallAction) -> Void
    
    open private(set) var registered: [(UITextField, (String) -> Bool, (Bool) -> Void)] = []
    
    public init(overall: @escaping (OverallAction) -> Void) {
        overallBlock = overall
    }
    
    
    open func register(field: UITextField?, validation: @escaping (String) -> Bool, action: @escaping (Bool) -> Void) {
        guard let field = field else {
            return
        }
        field.addTarget(self,
                        action: #selector(FormValidationManager.fieldDidLoseFocus(_:)),
                        for: UIControlEvents.editingDidEnd)
        field.addTarget(self,
                        action: #selector(FormValidationManager.fieldChanged(_:)),
                        for: UIControlEvents.editingChanged)
        field.addTarget(self,
                        action: #selector(FormValidationManager.pressedReturn(_:)),
                        for: UIControlEvents.editingDidEndOnExit)
        
        registered.append((field, validation, action))
    }
    
    open func checkAllFields() -> Set<UITextField> {
        var failed: Set<UITextField> = []
        
        for (field, validation, _) in registered {
            let text = field.text ?? ""
            if !validation(text) {
                failed.insert(field)
            }
        }
        
        return failed
    }
    
    open func checkAllFieldsAndPerformActions() -> Set<UITextField> {
        var failed: Set<UITextField> = []
        
        for (field, validation, action) in registered {
            let text = field.text ?? ""
            let validates = validation(text)
            action(validates)
            if !validates {
                failed.insert(field)
            }
        }
        
        return failed
    }
    
    
    //MARK: - UITextField Actions
    
    @IBAction open func fieldChanged(_ sender: UITextField) {
        guard let senderIndex = registered.index(where: { $0.0==sender}) else {
            return
        }
        
        if let validateTimer = validateTimer {
            validateTimer.invalidate()
        }
        
        func doValidation() {
            let failed = checkAllFields()
            
            let action = registered[senderIndex].2
            action(!failed.contains(sender))
            
            if failed.count > 0 {
                overallBlock(.someFailures(failed))
            } else {
                overallBlock(.allValidate)
            }
        }
        
        
        if delay > 0 {
            validateTimer = BlockTimer(timeInterval: delay, action: doValidation)
        } else {
            doValidation()
        }
    }
    
    @IBAction open func pressedReturn(_ sender: UITextField) {
        guard let senderIndex = registered.index(where: { $0.0==sender}) else {
            return
        }
        
        let failed = checkAllFields()
            
        let action = registered[senderIndex].2
        if failed.count == 0 {
            sender.resignFirstResponder()
            overallBlock(.successAction)
        } else {
            if failed.contains(sender) {
                action(false)
                sender.resignFirstResponder()
                overallBlock(.someFailures(failed))
            } else {
                action(true)
                let nextIndex = (senderIndex + 1) % registered.count
                let nextField = registered[nextIndex].0
                nextField.becomeFirstResponder()
            }
            overallBlock(.someFailures(failed))
        }
    }
    
    @IBAction open func fieldDidLoseFocus(_ sender: UITextField) {
        guard let senderIndex = registered.index(where: { $0.0==sender}) else {
            return
        }
        
        if let validateTimer = validateTimer {
            validateTimer.invalidate()
        }
        
        let failed = checkAllFields()
        let action = registered[senderIndex].2
        action(!failed.contains(sender))
        
        if failed.count > 0 {
            overallBlock(.someFailures(failed))
        } else {
            overallBlock(.allValidate)
        }
    }
}
