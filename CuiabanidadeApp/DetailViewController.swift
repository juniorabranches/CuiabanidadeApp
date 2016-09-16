//
//  DetailViewController.swift
//  Cuiabanidade
//
//  Created by Junior Abranches on 31/12/15.
//  Copyright © 2015 Junior Abranches. All rights reserved.
//

import UIKit
import MapKit
import GoogleMobileAds

class DetailViewController: UIViewController, MKMapViewDelegate, GADInterstitialDelegate {
    // image var
    
    //var img:UIImage!
    // title var
    var titleText:String!
    // description var
    var descriptionText:String!
    // hours var
    var hoursText:String!
    // phone var
    var phoneText:String!
    // address var
    var addressText:String!
    // lng var
    var lng:Double!
    // lat var
    var lat:Double!
    
    var siteText:String!
    
    var wifiText:String!
    
    var estacionamentoText:String!
    
    var categoryTextItem:String!
    
    // cover image view
    @IBOutlet weak var coverImage: UIImageView!
    // title label
    @IBOutlet weak var titleLabel: UILabel!
    // description label
    @IBOutlet weak var descriptionLabel: UILabel!
    // opening hours label
    @IBOutlet weak var openingHours: UILabel!
    // phone button
    @IBOutlet weak var phoneButton: UIButton!
    // address label
    @IBOutlet weak var address: UILabel!
    // map view
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var siteButton: UIButton!
    
    @IBOutlet weak var wifiLabel: UIImageView!
    
    @IBOutlet weak var noWifiLabel: UIImageView!
    
    @IBOutlet weak var estacionamentoLabel: UIImageView!
    
    @IBOutlet weak var noEstacionamentoLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init map
        initMap()
        // init data
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        // delete the title from the nav bar
      //  self.navigationController?.navigationBar.topItem?.title = titleText
        // animate the alpha of the navigation bar so the transition is ok
        UIView.animateWithDuration(0.25, delay: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.navigationController?.navigationBar.alpha = 0.8
        }, completion: nil)
    
 
    }
    
    override func viewWillDisappear(animated: Bool) {
        // set the alpha of the navigation bar back to 1
        self.navigationController?.navigationBar.alpha = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // init data from what we got in last controller
    func initData(){
        // set the title
        titleLabel.text = titleText
        // set the description
        descriptionLabel.text = descriptionText
        // set the opening hours
        openingHours.text = hoursText
        // set phone number
        phoneButton.setTitle(phoneText, forState: .Normal)
        phoneButton.setTitle(phoneText, forState: .Selected)
        phoneButton.setTitle(phoneText, forState: .Disabled)
        // set the address
        address.text = addressText
        
        siteButton.setTitle(siteText, forState: .Normal)
        siteButton.setTitle(siteText, forState: .Selected)
        siteButton.setTitle(siteText, forState: .Disabled)
        
        if wifiText == "0"
        {
            wifiLabel.hidden = true
            noWifiLabel.hidden = false
        }
        else
        {
            wifiLabel.hidden = false
            noWifiLabel.hidden = true
        }
        
        if estacionamentoText == "0"
        {
            estacionamentoLabel.hidden = true
            noEstacionamentoLabel.hidden = false
        }
        else
        {
            estacionamentoLabel.hidden = false
            noEstacionamentoLabel.hidden = true
        }
        
        // set the cover image file
        //coverImage.image = img
    //    coverImage.image = img


        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.coverImage.alpha = 1
        })
    }

    // init the map view
    func initMap(){
        // get the latitude and longitude
        let latitude:CLLocationDegrees = lat
        let longitude:CLLocationDegrees = lng

        // create the main area of the map
        let latDelta:CLLocationDegrees = 0.005
        let longDelta:CLLocationDegrees = 0.005
        
        // create the coordinate span
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        // create a location using the stored latitude and longituted
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // create the region
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // add the region to the map
        mapView.setRegion(region, animated: true)
        
        // add a custom annotation to the map
        let annotation = CustomAnnotation()
        annotation.coordinate = location
        annotation.title = titleText
        annotation.imageName = "pointer.png"
        mapView.addAnnotation(annotation)
        if #available(iOS 9.0, *) {
            mapView.mapType = MKMapType.HybridFlyover
        } else {
            mapView.mapType = MKMapType.Hybrid
        }

        
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
    
    // custom go back method as the default one is not visible
    @IBAction func goBack(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // reload data again
    @IBAction func callPhoneNumber(sender:AnyObject) {

        phoneText = phoneText.stringByReplacingOccurrencesOfString(" ", withString: "")
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneText)")!)
    }
    
    
    @IBAction func goSite(sender: AnyObject) {
        siteText = siteText.stringByReplacingOccurrencesOfString(" ", withString: "")
        UIApplication.sharedApplication().openURL(NSURL(string: "http://\(siteText)")!)
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        (segue.destinationViewController as! MapViewController).categoryName = self.categoryTextItem
        (segue.destinationViewController as! MapViewController).navigationController?.navigationBar.backItem!.title = self.categoryTextItem
        
        (segue.destinationViewController as! MapViewController).lati = lat
        (segue.destinationViewController as! MapViewController).long = lng
        (segue.destinationViewController as! MapViewController).localTitle = titleText
    }
    
    @IBAction func showMapSegue(sender: AnyObject)
    {
        performSegueWithIdentifier("MapSegue", sender: self)
        //self.navigationItem.title = categoryText
    }
    
    // share method
    @IBAction func share(sender:AnyObject) {
        // title of what we are going to share, customize here to whatever you want
        let title = "Conheça o \(titleText) através do Aplicativo Cuiabanidade."
        
        // create the controller
        let activityViewController = UIActivityViewController(activityItems: [title as AnyObject, coverImage.image as! AnyObject], applicationActivities:nil)
        
        // completion handler
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            //
        }
        
        // if iphone
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            // present it
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        else {
            let popup: UIPopoverController = UIPopoverController(contentViewController: activityViewController)
            // present it
            popup.presentPopoverFromRect(CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

    }

}
