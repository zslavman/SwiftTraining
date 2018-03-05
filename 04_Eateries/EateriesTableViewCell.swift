//
//  EateriesTableViewCell.swift
//  04_Eateries
//
//  Created by Admin on 14.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

// наша кастомная ячейка
class EateriesTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView! // картинка
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}









