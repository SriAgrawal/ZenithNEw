//
//  ZNRouteMapVC.swift
//  Zenith
//
//  Created by Anjali on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import MapKit
class ZNRouteMapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var navigationTitleLabel: UILabel!
    var destinationLat = NSString ()
    var destinationLong = NSString ()
    var navtitle = NSString ()
    
    //Mark:- ViewLifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationTitleLabel.text = navtitle as String
        customInit()
    }
    
    //Mark:- Helper Method
    func customInit()  {
        
        // Setting Source and Destination location. Will be changed accordingly during API Integration
        let sourceLocation = CLLocationCoordinate2D(latitude: kAppDelegate.currentLatitude, longitude: kAppDelegate.currentLongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLat.doubleValue , longitude: destinationLong.doubleValue)
        
        //Setting Place Markers
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Current Location"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = navtitle as String
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        if let polyArray = ZNDrawPolylineClass().drawRouteBetweenSource("\(kAppDelegate.currentLatitude),\(kAppDelegate.currentLongitude)", andDestination: ("\(destinationLat),\(destinationLong)"), on: self) {
            self.mapView.addOverlays(polyArray as! [MKOverlay])
        }
        
        self.zoomToFitMapAnnotations()
    }
    
    func zoomToFitMapAnnotations(){
        if mapView.annotations.count == 0 {
            return
        }
        
        var topLeftCoord = CLLocationCoordinate2D()
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;

        var bottomRightCoord = CLLocationCoordinate2D()
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for annotation in mapView.annotations {
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
        }

        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        
        // Add a little extra space on the sides
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
        region = mapView.regionThatFits(region);
        mapView.setRegion(region, animated: true)
    }
    
    //Mark:- Map View Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    //Mark:- Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    //Mark:- Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
