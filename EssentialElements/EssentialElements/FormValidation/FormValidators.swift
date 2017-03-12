//
//  FormValidators.swift
//  EssentialElements
//
//  Created by Holly Schilling on 3/8/17.
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

public struct FormValidators {
    
    private static var emailRegex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
    private static var urlRegex = try! NSRegularExpression(pattern: "^https?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?$", options: [.caseInsensitive])

    public static func verifyEmptyOr(next: @escaping (String) -> Bool) -> (String) -> Bool {
        return { (text: String) in
            if text.characters.count == 0 {
                return true
            } else {
                return next(text)
            }
        }
    }
    
    public static func notEmpty(_ text: String) -> Bool {
        return text.characters.count > 0
    }
    
    public static func isEmail(_ text: String) -> Bool {
        let count = emailRegex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.characters.count))
        return count > 0
    }
    
    public static func isUrl(_ text: String) -> Bool {
        let count = urlRegex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.characters.count))
        return count > 0
    }
    
    public static func matches(_ textField: UITextField) -> (String) -> Bool {
        return { [weak textField] (currentText: String) -> Bool in
            let matchText = textField?.text ?? ""
            return matchText==currentText
        }
    }
    
    public static func minimumLength(_ minLength: Int) -> (String) -> Bool {
        return { (text: String) -> Bool in
            return text.characters.count >= minLength
        }
    }
    
    public static func maximumLength(_ maxLength: Int) -> (String) -> Bool {
        return { (text: String) -> Bool in
            return text.characters.count <= maxLength
        }
    }
    
    public static func multiple(_ validators: [((String) -> Bool)]) -> (String) -> Bool {
        return { (text: String) -> Bool in
            for aVaidator in validators {
                let result = aVaidator(text)
                if result==false {
                    return result
                }
            }
            return true
        }
    }
}
