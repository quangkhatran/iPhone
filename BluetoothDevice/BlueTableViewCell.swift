//
//  BlueTableViewCell.swift
//  BluetoothDevice
//
//  Created by Quang Kha Tran on 28/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class BlueTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
