//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Thao Doan on 4/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControlViewCell: RatingControl!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
