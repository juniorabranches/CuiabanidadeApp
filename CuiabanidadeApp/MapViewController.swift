//
//  MapViewController.swift
//  Cuiabanidade
//
//  Created by Junior Abranches on 31/12/15.
//  Copyright © 2015 Junior Abranches. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class MapViewController: UIViewController, MKMapViewDelegate {
    // map view
    @IBOutlet weak var mapView: MKMapView!
    
    var categoryName : String!
    // lng var
    var long:Double!
    // lat var
    var lati:Double!
    // points array
    var localTitle : String!
    var points = Array<CKRecord>()
    // stored selected annotation used to know which attraction we have to show
    var selectedAnnotation:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init the map
        initMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // set the navigation bar to be visible
        self.navigationController?.navigationBarHidden = false
   //     self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.navigationBar.translucent = false
        //self.navigationController?.navigationBar.backItem!.title = ""
        self.navigationController?.navigationBar.backItem!.title = categoryName

        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = "Voltar"
        self.navigationItem.title = localTitle
    
    }
    
    // init the map
    func initMap() {
        // create the latitude and longitude (change it here to the center of your city)
        let latitude:CLLocationDegrees = lati
        let longitude:CLLocationDegrees = long
        
        // create the area that will be seen
        let latDelta:CLLocationDegrees = 0.05
        let longDelta:CLLocationDegrees = 0.05
        
        // create a coordinate
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //create a location using the latitude and longitude
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // create the region
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // add the region to the map
        mapView.setRegion(region, animated: true)
        
        // add a custom annotation to the map
        let annotation = CustomAnnotation()
        annotation.coordinate = location
        annotation.title = localTitle
        annotation.imageName = "pointer.png"
        mapView.addAnnotation(annotation)
        if #available(iOS 9.0, *) {
            mapView.mapType = MKMapType.HybridFlyover
        } else {
            mapView.mapType = MKMapType.Hybrid
        }
    }
    
    
    // add annotations to the map
    func addAnnotations(lat:Double,lng:Double,title:String,index:Int){
        // create a location with the given latitude and longitude
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
        // add annotation to the map
        let annotation = CustomAnnotation()
        // set the location
        annotation.coordinate = location
        // set the title
        annotation.title = title
        // set the image name
        annotation.imageName = "pointer.png"
        // set it an index
        annotation.index = index
        
        // add it to the map view
        mapView.addAnnotation(annotation)
    }
    
    // mpa view, create annotations
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // if annotation is not custom, break the function
        if !(annotation is CustomAnnotation) {
            return nil
        }
        
        // create a reuse id
        let reuseId = ""
        // create an annotation
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        // if nil, create a new one
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        // cast it as custom annotation
        let cpa = annotation as! CustomAnnotation
        // set the custom image
        anView!.image = UIImage(named:cpa.imageName)
        
        // return the annotation
        return anView
    }
    
    
  
}
