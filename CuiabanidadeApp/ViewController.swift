//
//  ViewController.swift
//  Cuiabanidade
//
//  Created by Junior Abranches on 30/12/15.
//  Copyright © 2015 Junior Abranches. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // cover image
    @IBOutlet weak var coverImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call animate cover image
        animateCoverImage(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide navigation bar
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // recursive function used to animate cover image
    func animateCoverImage (direction:Bool){
        // change here the first parameter if you want it faster
        UIView.animateWithDuration(20.0, delay: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            // switch direction move to right or move to left
            if direction {
                // set new position
                self.coverImage.transform = CGAffineTransformTranslate(self.coverImage.transform, -(self.coverImage.bounds.width - UIScreen.mainScreen().bounds.width), 0)
            }
            else {
                // set new position
                self.coverImage.transform = CGAffineTransformTranslate(self.coverImage.transform, self.coverImage.bounds.width - UIScreen.mainScreen().bounds.width, 0)
            }
            
        }) { (Bool) -> Void in
            // when completed, animate it again but changing direction
            self.animateCoverImage(!direction)
        }
    }
    
    // set status bar hidden
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

