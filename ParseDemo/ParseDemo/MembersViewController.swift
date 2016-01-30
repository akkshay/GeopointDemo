//
//  MemebrsViewController.swift
//  ParseDemo
//
//  Created by Akkshay Khoslaa on 10/21/15.
//  Copyright © 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
class MembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MemberTableViewCellDelegate, CLLocationManagerDelegate {
    
    var memberObjects = Array<PFObject>()
    let locationManager = CLLocationManager()
    var currGeoPoint: PFGeoPoint!
    @IBOutlet weak var membersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        var currentLocation = locationManager.location
        currGeoPoint = PFGeoPoint(location: currentLocation)
        print(currGeoPoint)
                
    
        self.navigationController!.navigationBar.hidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.678, blue: 1, alpha: 1)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? Dictionary
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        membersTableView.delegate = self
        membersTableView.dataSource = self
        getMembers()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMembers() {
        let query = PFQuery(className:"User")
        query.whereKey("location", nearGeoPoint: currGeoPoint, withinMiles: 20)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    self.memberObjects = objects
                }
                self.membersTableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    
    func hit(cell: MemberTableViewCell) {
        let query = PFQuery(className:"User")
        query.whereKey("firstName", equalTo:cell.memberName.text!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    for object in objects {
                        let currTotalHits = object["hits"] as! Int
                        let newTotalHits = currTotalHits + 1
                        object["hits"] = newTotalHits
                        object.saveInBackgroundWithTarget(nil, selector: nil)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! MemberTableViewCell
        
        cell.memberProfilePic.layer.cornerRadius = cell.memberProfilePic.frame.size.width/2
        cell.memberProfilePic.clipsToBounds = true
        cell.delegate = self
        cell.memberName.text = memberObjects[indexPath.row]["firstName"] as! String
        cell.memberProfilePic.image = nil
        memberObjects[indexPath.row]["profilePicture"]!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image1 = UIImage(data:imageData!)
                cell.memberProfilePic.image = image1
            }
        }
        var cellUserGeoPoint = memberObjects[indexPath.row]["location"] as! PFGeoPoint
        var distance = currGeoPoint.distanceInMilesTo(cellUserGeoPoint)
        var distanceLabel = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.width/2, y: (cell.frame.height-30)/2, width: 50, height: 30))
        distanceLabel.font = UIFont.systemFontOfSize(13)
        distanceLabel.textColor = UIColor.grayColor()
        distanceLabel.text = String(distance) + " mi"
        cell.addSubview(distanceLabel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
        
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
