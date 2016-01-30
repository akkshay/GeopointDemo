//
//  MemberTableViewCell.swift
//  ParseDemo
//
//  Created by Akkshay Khoslaa on 10/21/15.
//  Copyright © 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit
protocol MemberTableViewCellDelegate {
    func hit(cell: MemberTableViewCell)
}
class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberProfilePic: UIImageView!
    
    var delegate:MemberTableViewCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func hitMember(sender: AnyObject) {
        delegate?.hit(self)
        
        let plusFilled = UIImage(named: "plusFilled")
        hitButton.setImage(plusFilled, forState: .Normal)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
