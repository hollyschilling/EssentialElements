//
//  MapViewController.swift
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

open class MapViewController: UIViewController, MKMapViewDelegate {
    
    open var mapView: MKMapView?
    
    open override func loadView() {
        super.loadView()
        
        let map = MKMapView(frame: view.bounds)
        map.delegate = self
        view.addFullSized(subview: map)
    }
    
    //MARK: - MKMapViewDelegate
    
    open func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    open func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    open func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        
    }
    
    open func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    open func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        
    }
    
    open func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        
    }
    
    open func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
    }
    
    open func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    open func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
    }
    
    open func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    open func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        
    }
    
    open func mapView(_ mapView: MKMapView, didDeselect annotationView: MKAnnotationView) {
        
    }
    
    open func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        
    }
    
    open func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        
    }
    
    open func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    open func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        
    }
    
    open func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
    
    open func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
    }
    
    open func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKOverlayRenderer(overlay: overlay)
    }
    
    open func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
        
    }
    
}
