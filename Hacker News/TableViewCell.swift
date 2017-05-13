//
//  TableViewCell.swift
//  Hacker News
//
//  Created by Finn Gaida on 13.05.17.
//  Copyright © 2017 Finn Gaida. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var previewView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
