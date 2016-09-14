//
//  PhotoFeedTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 26.08.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PhotoFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
