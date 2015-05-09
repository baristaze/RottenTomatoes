//
//  MoviesTableCell.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/8/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class MoviesTableCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSnopsisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
