//
//  ListCollectionViewController.swift
//  EssentialElements
//
//  Created by Holly Schilling on 3/7/17.
//  Copyright © 2017 Better Practice Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

open class ListCollectionViewController<ItemType: NSFetchRequestResult>: UICollectionViewController, NSFetchedResultsControllerDelegate {

    public enum CollectionViewChange {
        case insert(IndexPath)
        case delete(IndexPath)
        case move(IndexPath, IndexPath)
        case update(IndexPath)
    }
    
    private var pendingChanges: [CollectionViewChange] = []
    
    open var viewDidLoadHandler: ((_ controller: ListCollectionViewController<ItemType>) -> Void)? {
        didSet {
            if isViewLoaded {
                viewDidLoadHandler?(self)
            }
        }
    }
    
    open var didSelectItemHandler: ((_ controller: ListCollectionViewController<ItemType>, _ indexPath: IndexPath) -> Void)?
    
    open weak var badgingTarget: UIViewController? {
        didSet {
            oldValue?.tabBarItem.badgeValue = nil
            updateBadge()
        }
    }
    
    open var contents: NSFetchedResultsController<ItemType>? {
        didSet {
            contents?.delegate = self
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
    
    open func applyChange(_ change: CollectionViewChange) {
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
    
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard contents == controller else {
            return
        }

        pendingChanges = []
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
            for aChange in self.pendingChanges {
                self.applyChange(aChange)
            }
        })
    }
}
