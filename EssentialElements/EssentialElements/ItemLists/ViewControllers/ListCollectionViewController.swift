//
//  ListCollectionViewController.swift
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

open class ListCollectionViewController<ItemType: NSFetchRequestResult>: UICollectionViewController, NSFetchedResultsControllerDelegate {

    open var viewDidLoadHandler: ((_ controller: ListCollectionViewController<ItemType>) -> Void)? {
        didSet {
            if isViewLoaded {
                viewDidLoadHandler?(self)
            }
        }
    }
    
    open var didSelectItemHandler: ((_ controller: ListCollectionViewController<ItemType>, _ indexPath: IndexPath) -> Void)?
    
    open var contents: NSFetchedResultsController<ItemType>? {
        didSet {
            contents?.delegate = self
            updateBadge()
            collectionView?.reloadData()
        }
    }
    
    open weak var badgingTarget: UIViewController? {
        didSet {
            oldValue?.tabBarItem.badgeValue = nil
            updateBadge()
        }
    }
    
    //MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        updateBadge()
        viewDidLoadHandler?(self)
    }
    
    open override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        updateBadge()
    }
    
    //MARK: - Instance Methods
    
    open func updateBadge() {
        guard let badgingTarget = badgingTarget else {
            return
        }
        let count = contents?.fetchedObjects?.count ?? 0
        if count > 0 {
            badgingTarget.tabBarItem.badgeValue = count.description
        } else {
            badgingTarget.tabBarItem.badgeValue = nil
        }
    }
    
    open func configure<ItemViewType: ItemView<ItemType>>(cell: ItemCollectionViewCell<ItemViewType>, for indexPath: IndexPath) {
        let itemView: ItemViewType = cell.itemView
        let item: ItemType? = contents?.object(at: indexPath)
        itemView.item = item
    }
    
    open func apply(changes: [FetchedResultsChange]) {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.performBatchUpdates({ 
            for aChange in changes {
                self.apply(change: aChange)
            }
        })
    }
    
    open func apply(change: FetchedResultsChange) {
        guard let collectionView = collectionView else {
            return
        }
        
        switch change {
        case .insert(let indexPath):
            collectionView.insertItems(at: [indexPath])
        case .delete(let indexPath):
            collectionView.deleteItems(at: [indexPath])
        case .move(let oldIndexPath, let newIndexPath):
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
        case .update(let indexPath):
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    //MARK: - UICollectionView Delegate and DataSource
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents?.sections?.count ?? 0
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents?.sections?[section].numberOfObjects ?? 0
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemHandler?(self, indexPath)
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    private var pendingChanges: [FetchedResultsChange] = []
    
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard contents == controller else {
            return
        }

        pendingChanges = []
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {
        guard contents == controller else {
            return
        }

        switch type {
        case .insert:
            pendingChanges.append(.insert(newIndexPath!))
        case .delete:
            pendingChanges.append(.delete(indexPath!))
        case .update:
            pendingChanges.append(.update(indexPath!))
        case .move:
            pendingChanges.append(.move(indexPath!, newIndexPath!))
        }
    }
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let collectionView = collectionView, contents == controller else {
            return
        }
        
        collectionView.performBatchUpdates({
            self.apply(changes: self.pendingChanges)
        })
    }
}
