//
//  DetailTableViewCell.swift
//  04_Eateries
//
//  Created by Admin on 20.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
