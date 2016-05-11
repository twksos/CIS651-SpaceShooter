//
//  UserScoreTableViewCell.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright © 2016 Guangcheng Wei. All rights reserved.
//

import UIKit

class UserScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
