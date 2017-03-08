//
//  ListTableViewController.swift
//  EssentialElements
//
//  Created by Holly Schilling on 2/25/17.
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

open class ListTableViewController<ItemType: NSFetchRequestResult>: UITableViewController, NSFetchedResultsControllerDelegate {
    
    open var viewDidLoadHandler: ((_ controller: ListTableViewController<ItemType>) -> Void)? {
        didSet {
            if isViewLoaded {
                viewDidLoadHandler?(self)
            }
        }
    }
    
    open var didSelectItemHandler: ((_ controller: ListTableViewController<ItemType>, _ indexPath: IndexPath) -> Void)?
    
    open var contents: NSFetchedResultsController<ItemType>? {
        didSet {
            contents?.delegate = self
            updateBadge()
            tableView?.reloadData()
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
    
    open func configure<ItemViewType: ItemView<ItemType>>(cell: ItemTableViewCell<ItemViewType>, for indexPath: IndexPath) {
        let itemView: ItemViewType = cell.itemView
        let item: ItemType? = contents?.object(at: indexPath)
        itemView.item = item
    }
    
    open func apply(changes: [FetchedResultsChange]) {
        guard let tableView = tableView else {
            return
        }
        
        tableView.beginUpdates()
        for aChange in changes {
            apply(change: aChange)
        }
        tableView.endUpdates()
    }
    
    open func apply(change: FetchedResultsChange) {
        guard let tableView = tableView else {
            return
        }
        switch change {
        case .insert(let indexPath):
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete(let indexPath):
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move(let oldIndexPath, let newIndexPath):
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update(let indexPath):
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    //MARK: - UITableView Delegate and DataSource
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return contents?.sections?.count ?? 0
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents?.sections?[section].numberOfObjects ?? 0
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemHandler?(self, indexPath)
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = contents?.sections?[section]
        return sectionInfo?.name
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard controller == contents else {
            return
        }
        
        tableView.beginUpdates()
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {
        guard controller == contents else {
            return
        }
        
        switch type {
        case .insert:
            apply(change: .insert(newIndexPath!))
        case .delete:
            apply(change: .delete(indexPath!))
        case .update:
            apply(change: .update(indexPath!))
        case .move:
            apply(change: .move(indexPath!, newIndexPath!))
        }
    }

    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateBadge()
        guard controller == contents else {
            return
        }
        
        tableView.endUpdates()
    }
}
