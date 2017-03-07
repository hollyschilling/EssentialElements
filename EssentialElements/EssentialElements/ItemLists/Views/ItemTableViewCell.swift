//
//  ItemTableViewCell.swift
//  EssentialElements
//
//  Created by Holly Schilling on 2/26/17.
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

open class ItemTableViewCell<ItemViewType: UIView>: UITableViewCell {
    
    open var itemView: ItemViewType = ItemViewType(frame: CGRect.zero)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        itemView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        itemView.frame = contentView.bounds
        contentView.addSubview(itemView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        itemView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        itemView.frame = contentView.bounds
        contentView.addSubview(itemView)
    }
}
