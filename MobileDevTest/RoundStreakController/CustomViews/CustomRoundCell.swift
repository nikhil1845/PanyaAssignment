//
//  CustomRoundCell.swift
//  MobileDevTest
//
//  Created by SEPL MAC on 18/07/18.
//  Copyright © 2018 nik MAC. All rights reserved.
//

import UIKit

class CustomRoundCell: UITableViewCell {

    @IBOutlet weak var roundHolderView: UIView!
    
    @IBOutlet weak var bonusButton: UIButton!
    
    @IBOutlet weak var recivedmark: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
