//
//  SpotlightViewController.swift
//  ParseDemo
//
//  Created by Akkshay Khoslaa on 10/21/15.
//  Copyright © 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class SpotlightViewController: UIViewController {

    @IBOutlet weak var memberProfPic: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberHits: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.678, blue: 1, alpha: 1)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? Dictionary
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()        
        memberProfPic.layer.cornerRadius = memberProfPic.frame.size.width/2
        memberProfPic.clipsToBounds = true
        getMemberInfo()
        // Do any additional setup after loading the view.
    }
    
    func getMemberInfo() {
        let query = PFQuery(className:"User")
        query.orderByDescending("hits")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    self.memberName.text = objects[0]["firstName"] as! String
                    let numHits = objects[0]["hits"] as! Int
                    self.memberHits.text = String(numHits)
                    let imageFile = objects[0]["profilePicture"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            let image1 = UIImage(data:imageData!)
                            self.memberProfPic.image = image1
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
