//
//  AnnotatedMapViewController.swift
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
import MapKit
import CoreData

open class AnnotatedMapViewController<ItemType>: MapViewController, NSFetchedResultsControllerDelegate where ItemType: MKAnnotation & NSFetchRequestResult {
    
    open var viewDidLoadHandler: ((_ controller: AnnotatedMapViewController<ItemType>) -> Void)? {
        didSet {
            if isViewLoaded {
                viewDidLoadHandler?(self)
            }
        }
    }
    
    open var didSelectItemHandler: ((_ controller: AnnotatedMapViewController<ItemType>, _ item: ItemType) -> Void)?
    
    open var contents: NSFetchedResultsController<ItemType>? {
        didSet {
            contents?.delegate = self
            updateBadge()
            reloadAnnotations()
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
    
    open func reloadAnnotations() {
        guard let mapView = mapView else {
            return
        }
        
        // Remove all annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotations
        let newAnnotations = contents?.fetchedObjects ?? []
        mapView.addAnnotations(newAnnotations)
    }
    
    //MARK: - MKMapViewDelegate
    
    open override func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        guard let item = annotationView.annotation as? ItemType else {
            return
        }
        didSelectItemHandler?(self, item)
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard controller == contents else {
            return
        }
        
        // Do Nothing
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {
        guard controller == contents else {
            return
        }
        guard let mapView = mapView, let annotation = anObject as? ItemType else {
            return
        }
        
        switch type {
        case .insert:
            mapView.addAnnotation(annotation)
        case .delete:
            mapView.removeAnnotation(annotation)
        case .update:
            break // Do Nothing
        case .move:
            break // Do Nothing
        }
    }
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateBadge()
        guard controller == contents else {
            return
        }
        
        // Do Nothing
    }
}
