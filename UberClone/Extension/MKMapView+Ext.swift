//
//  MKMapView+Ext.swift
//  UberClone
//
//  Created by wingswift on 03/10/2021.
//

import MapKit

extension MKMapView {
    
    func zoomToFit(annotations: [MKAnnotation]) {
        var zoomRect = MKMapRect.null
        
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 75, left: 75, bottom: 200, right: 75)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }
}
