//
//  SimpleListCollectionViewController.swift
//  EssentialElements
//
//  Created by Holly Schilling on 3/7/17.
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
import CoreData

open class SimpleListCollectionViewController<ItemType: NSFetchRequestResult, ItemViewType: ItemView<ItemType>>: ListCollectionViewController<ItemType> {
    
    open var itemIdentifier: String = "ItemIdentifier"
    
    open override func viewDidLoad() {
        // Register View first so that it is done before `viewDidLoadHandler` is called
        collectionView?.register(ItemCollectionViewCell<ItemViewType>.self, forCellWithReuseIdentifier: itemIdentifier)
        super.viewDidLoad()
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath) as! ItemCollectionViewCell<ItemViewType>
        configure(cell: cell, for: indexPath)
        return cell
    }
}
