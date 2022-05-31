//
//  TableViewCell.swift
//  minimal
//
//  Created by Truong Nhat Anh on 31/05/2022.
//

import UIKit
import SwipeCellKit

class TableViewCell: SwipeTableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
