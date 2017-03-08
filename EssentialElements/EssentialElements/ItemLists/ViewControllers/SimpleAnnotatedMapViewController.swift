//
//  SimpleAnnotatedMapViewController.swift
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

open class SimpleAnnotatedMapViewController<ItemType, AnnotationViewType: MKAnnotationView>: AnnotatedMapViewController<ItemType> where ItemType: MKAnnotation & NSFetchRequestResult {

    open var annotationViewIdentifier: String = "annotationViewIdentifier"
    
    open var configureAnotationView: ((SimpleAnnotatedMapViewController<ItemType, AnnotationViewType>, _ annotationView: AnnotationViewType) -> Void)?
    open var calloutAccessoryControlTapped: ((SimpleAnnotatedMapViewController<ItemType, AnnotationViewType>, _ item: ItemType) -> Void)?
    
    open override func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let item = annotation as? ItemType else {
            return super.mapView(mapView, viewFor: annotation)
        }
        
        let annotationView: AnnotationViewType = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) as? AnnotationViewType
            ?? AnnotationViewType(annotation: item, reuseIdentifier: annotationViewIdentifier)
        
        annotationView.annotation = item
        configureAnotationView?(self, annotationView)
        return annotationView
    }
    
    open override func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let item = annotationView.annotation as? ItemType else {
            return
        }
        calloutAccessoryControlTapped?(self, item)
    }

}
