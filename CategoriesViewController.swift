//
//  CategoriesViewController.swift
//  Cuiabanidade
//
//  Created by Junior Abranches on 30/12/15.
//  Copyright © 2015 Junior Abranches. All rights reserved.
//

//

import UIKit
import GoogleMobileAds
import Alamofire

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,GADBannerViewDelegate {
    // categories table view
    @IBOutlet weak var tableView: UITableView!
    // activity indicator view used to show loading process of data
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    // error used to inform users that data has not been loaded
    @IBOutlet weak var connectionErrorButton:UIButton!

    var json : JSON = JSON.null


    
    // categories array
   // var categories = Array<CKRecord>()
    // selected category index used to know which one has been pressed
    var selectedCategory = 0
    
    let categoriasPhp : String = " AQUI VAI A URL DE CATEGORIAS "

    
    // ads views
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    // constraints
    @IBOutlet weak var adsHeightConstraint: NSLayoutConstraint!
    
    var refreshControl1 = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init ads
       //initAds()
        
        lerCatergorias(categoriasPhp)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    @IBAction func refreshButton(sender: AnyObject)
    {
        //self.tableView.hidden = true
        //novasCategorias()
        //self.tableView.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        // set navigation bar hidden

        self.navigationController?.navigationBarHidden = false
         self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backItem!.title = ""
        self.navigationItem.hidesBackButton = true
         self.navigationItem.title = "Categorias"
        
       // let refreshButton = UIImage(named: "refreshIcon1")
       // self.editButtonItem().image = refreshButton
       // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadAgain:"), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // reload data again
    @IBAction func reloadAgain(sender:AnyObject)
    {
        lerCatergorias(categoriasPhp)
    }
    
    func lerCatergorias(categoriasPhp : String)
    {
        self.tableView.hidden = true
        activityIndicatorView.hidden = false
        connectionErrorButton.hidden = true
        Alamofire.request(.GET, categoriasPhp).responseJSON { response in
            guard let data = response.result.value else{
                
                self.activityIndicatorView.hidden = true
                self.connectionErrorButton.hidden = false
                
                //print("Request failed with error")
                //print(response.result.value)
                return
            }
            //     print(response.result.value);
            self.activityIndicatorView.hidden = true
            self.connectionErrorButton.hidden = true
            self.json = JSON(data)
            //print(self.json)
            //print(self.json.type)
            //print(self.json.count)
            self.tableView.hidden = false
            self.tableView.reloadData()
            
        }
    }
    
    // table view, number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return json.count
        switch self.json.type
        {
        case Type.Array:
            return self.json.count
        default:
            return 1
        }
    }
    

    // table view, create each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // create a categories cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Categories", forIndexPath: indexPath)
        
        // Get row index
        let row = indexPath.row
        
        //Make sure post title is a string
        if let title = self.json[row]["Title"].string{
            (cell.viewWithTag(20) as! UILabel).text = title
        }

        
         if var image =  self.json[row]["Pathimage"].string{
            
            if image != "null"{
                
                image = "AQUI VAI URL DA IMAGEM" + image;
                
                let myProfilePictureURL = NSURL(string: image)
                let imageData = NSData(contentsOfURL: myProfilePictureURL!)
                
                ImageLoader.sharedLoader.imageForUrl(image, completionHandler:{(image: UIImage?, url: String) in
                    (cell.viewWithTag(19) as! UIImageView).image = image!
                })
            }
        }
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            cell.contentView.alpha = 1
        })
        
        // create a gradient to ensure the text is visible
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 0.6).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor]
        gradient.frame = cell.bounds
        cell.viewWithTag(22)!.layer.sublayers?.removeAll()
        cell.viewWithTag(22)!.layer.insertSublayer(gradient, atIndex: 0)
        
        // return the cell
        return cell
    }
    
    // table view, set height for cell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125.0
    }
    
    // table view, cell has been selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // store the selected category index
        selectedCategory = indexPath.row
        performSegueWithIdentifier("InfoSegue", sender: self)
    }
    
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if the segue is InfoSegue
        if segue.identifier == "InfoSegue" {
            // set the category id to be used on the info data load
            let varId = json[selectedCategory]["Id"].string

            (segue.destinationViewController as! InfoViewController).categoryId = varId!
            // set the title of the next controller
            print(json[selectedCategory]["Title"])
            print(json[selectedCategory]["Type"])
            print(json[selectedCategory]["Id"])

            let varTitle = json[selectedCategory]["Title"].string

            (segue.destinationViewController as! InfoViewController).categoryTitle = varTitle!
        }
    }
    
    // init ads
    func initAds() {
        // decide if you want to use Google AdMob
        let useAds:Int = 0;
        switch useAds {
        case 1:
            // start Google AdMob request
            googleAdMobInit()
            break;
        default:
            // show no ads
            deleteAds()
            break;
        }
    }
    
    // Google AdMob init
    func googleAdMobInit() {
        // Replace this ad unit ID with your own ad unit ID.
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        let request:GADRequest = GADRequest();
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
        request.testDevices = []
        bannerView.loadRequest(request);
    }
    
    // Delete Ads
    func deleteAds() {
        adsHeightConstraint.constant = 0
        adsView.updateConstraints()
    }
}
