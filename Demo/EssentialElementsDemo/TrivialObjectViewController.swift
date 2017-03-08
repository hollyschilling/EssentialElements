//
//  TrivialObjectViewController.swift
//  EssentialElementsDemo
//
//  Created by Holly Schilling on 3/5/17.
//  Copyright © 2017 BetterPractice. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import EssentialElements

class TrivialObjectViewController: UIViewController {
    
    // Create CoreData Stack (This is normally done by the AppDelegate)
    let managedObjectContext: NSManagedObjectContext = {
        let url = Bundle.main.url(forResource: "TrivialModel", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: url!)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                            configurationName: nil,
                                            at: nil,
                                            options: nil)
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    lazy var trivialItemList: SimpleListTableViewController<TrivialObject, TrivialItemView> = SimpleListTableViewController(style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add selection handler
        trivialItemList.didSelectItemHandler = { [unowned self] (_, indexPath: IndexPath) in
            guard let object = self.trivialItemList.contents?.object(at: indexPath), let date = object.creationDate else {
                return
            }
            self.showAlert(for: date as Date)
        }

        // Ensure UIResponder chain is valid
        trivialItemList.willMove(toParentViewController: self)
        addChildViewController(trivialItemList)
        trivialItemList.didMove(toParentViewController: self)

        // Add NSFetchedResultsController to ListViewController
        let fr: NSFetchRequest<TrivialObject> = NSFetchRequest(entityName: "TrivialObject")
        fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: managedObjectContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        try! frc.performFetch()
        trivialItemList.contents = frc
        
        // Add ListViewController view as a child view
        let childView: UIView = trivialItemList.view
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childView.frame = view.bounds
        view.addSubview(childView)
    }
    
    @IBAction func createTrivialObject(_ sender: Any) {
        let newObject = NSEntityDescription.insertNewObject(forEntityName: "TrivialObject", into: managedObjectContext) as! TrivialObject
        newObject.creationDate = Date() as NSDate
        try! managedObjectContext.save()
    }
    
    func showAlert(for date: Date) {
        let age = Int(-date.timeIntervalSinceNow)
        
        let alert = UIAlertController(
            title: "Cell Selected",
            message: "Selected cell was created \(age) second(s) ago.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default,
            handler: { (_) in
                let tableView: UITableView = self.trivialItemList.tableView
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
        }))
        present(alert, animated: true, completion: nil)
    }
}
