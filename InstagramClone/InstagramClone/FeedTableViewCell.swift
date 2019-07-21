//
//  FeedTableViewCell.swift
//  InstagramClone
//
//  Created by Quang Kha Tran on 21/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postedImage: UIImageView!
    
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var userInfo: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
