 //
//  InfoViewController.swift
//  Cuiabanidade
//
//  Created by Junior Abranches on 30/12/15.
//  Copyright © 2015 Junior Abranches. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CloudKit
import Alamofire

class InfoViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, GADBannerViewDelegate  {
    // info collection view
    @IBOutlet weak var collectionView: UICollectionView!
    // activity indicator
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    // error used to inform users that data has not been loaded
    @IBOutlet weak var connectionErrorButton:UIButton!
    
    // categories array
    var categories = Array<CKRecord>()
    // category id
    var categoryId: String = ""
    // category title
    var categoryTitle : String = ""
    // selected category index used to knpw which cell has been selected
    var selectedCategory = 0
    
    var viewInfo : JSON = JSON.null
    let infosPHP : String = "AQUI VAI A URL DAS INFOS DAS CATEGORIAS"
    
    
    // ads views
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    // constraints
    @IBOutlet weak var adsHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // initData()
        
        getInfos(infosPHP)
        // Do any additional setup after loading the view.
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       // let refreshButton = UIImage(named: "refreshIcon1")
       // self.editButtonItem().image = refreshButton
       // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadAgain:"), animated: true)

        
        self.title = categoryTitle

        
        // init ads
        initAds()
    }
    
    
    func getInfos(infos : String)
    {
        
        let parameters : [String:AnyObject] = [
            "category" : categoryId
        ]

        self.collectionView.hidden = true
        // show activity indicator
        self.activityIndicatorView.hidden = false
        // hide connection error button
        self.connectionErrorButton.hidden = true
        
        Alamofire.request(.GET, infos, parameters:parameters)
            .responseJSON { response in
            
                guard let data = response.result.value else{
                    self.connectionErrorButton.hidden = false
                    self.activityIndicatorView.hidden = true
                    //print("Request failed with error")
                    return
                }
                
                self.viewInfo = JSON(data)
                self.connectionErrorButton.hidden = true
                self.activityIndicatorView.hidden = true
                //print(self.viewInfo)
                //print(self.viewInfo.type)
                self.categories.removeAll()
                //self.categories = self.json.count
                self.collectionView.hidden = false
                self.collectionView.reloadData()
                //self.tableView.reloadData()
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // show the navigation bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backItem!.title = "Categorias"
        self.navigationItem.title = categoryTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // reload data again
    @IBAction func reloadAgain(sender:AnyObject) {
       getInfos(infosPHP)
    }
    
    // collection view, number of items
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int {
        return viewInfo.count
    }
    
    // collection view, create each cell
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // create a Info cell
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Info", forIndexPath: indexPath)
        // set its title
        if let title = self.viewInfo[indexPath.row]["Title"].string{
            (cell.viewWithTag(8) as! UILabel).text = title
        }
        
        
        if var image =  self.viewInfo[indexPath.row]["Image"].string{
            
            if image != "null"{
                
                image = "AQUI VAI A URL DA IMAGEM" + image;
                
                let myProfilePictureURL = NSURL(string: image)
                _ = NSData(contentsOfURL: myProfilePictureURL!)
                
                ImageLoader.sharedLoader.imageForUrl(image, completionHandler:{(image: UIImage?, url: String) in
                    (cell.viewWithTag(7) as! UIImageView).image = image!
                })
            }
        }
       // (cell.viewWithTag(8) as! UILabel).text = (categories[indexPath.row] as CKRecord)["title"] as? String
        //(cell.viewWithTag(7) as! UIImageView).image = UIImage(data: ((categories[indexPath.row] as CKRecord)["image"] as? NSData)!)

        UIView.animateWithDuration(0.4, animations: { () -> Void in
            cell.viewWithTag(7)!.alpha = 1
            cell.viewWithTag(9)!.alpha = 1
        })
        // return the cell
        return cell
    }
    
    // collection view, set layout
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        // cell width is half screen minus insets and height same as width without insets
        let cellSize = CGSize(width: collectionView.bounds.width/2 - 3 , height: collectionView.bounds.width/2)
        // return cell size
        return cellSize
    }
    
    // collection view, cell has been selected
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // store the selected category index
        selectedCategory = indexPath.row
        // perform detail segue
        performSegueWithIdentifier("DetailSegue", sender: self)
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if segues is detail segue
        if segue.identifier == "DetailSegue"{
            // set all data needed to show in the detail controller
            (segue.destinationViewController as! DetailViewController).titleText = viewInfo[selectedCategory]["Title"].string
            
            
           // (segue.destinationViewController as! DetailViewController).img = self.viewInfo[selectedCategory]["Image"].object as! NSData
            
            if var image =  self.viewInfo[selectedCategory]["Image"].string{
                
                if image != "null"{
                    
                    image = "AQUI VAI A URL DA IMAGEM" + image;
                    
                    let myProfilePictureURL = NSURL(string: image)
                    let imageData = NSData(contentsOfURL: myProfilePictureURL!)
    
                    ImageLoader.sharedLoader.imageForUrl(image, completionHandler:{(image: UIImage?, url: String) in

                        (segue.destinationViewController as! DetailViewController).coverImage.image = image
    
                        
                    })
                }
            }
            
            
            (segue.destinationViewController as! DetailViewController).descriptionText = viewInfo[selectedCategory]["Description"].string
            (segue.destinationViewController as! DetailViewController).hoursText = viewInfo[selectedCategory]["Ophours"].string
            (segue.destinationViewController as! DetailViewController).phoneText = (viewInfo[selectedCategory]["Phone"].string)!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())
            (segue.destinationViewController as! DetailViewController).addressText = viewInfo[selectedCategory]["Address"].string
            (segue.destinationViewController as! DetailViewController).lat = viewInfo[selectedCategory]["Latitude"].doubleValue
            (segue.destinationViewController as! DetailViewController).lng = viewInfo[selectedCategory]["Longitude"].doubleValue
            (segue.destinationViewController as! DetailViewController).siteText = viewInfo[selectedCategory]["Website"].string
            
            (segue.destinationViewController as! DetailViewController).wifiText = viewInfo[selectedCategory]["Hotspotwififree"].string
            
            (segue.destinationViewController as! DetailViewController).estacionamentoText = viewInfo[selectedCategory]["Parking"].string
            
            (segue.destinationViewController as! DetailViewController).categoryTextItem = categoryTitle
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
        request.testDevices = [
            "2077ef9a63d2b398840261c8221a0c9a",  // Eric's iPod Touch
            kGADSimulatorID // iphone simulator
        ]
        
        bannerView.loadRequest(request);
    }
    
    // Delete Ads
    func deleteAds() {
        adsHeightConstraint.constant = 0
        adsView.updateConstraints()
    }
    
}

