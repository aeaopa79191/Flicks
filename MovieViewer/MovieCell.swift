//
//  MovieCell.swift
//  MovieViewer
//
//  Created by KaKin Chiu on 1/16/16.
//  Copyright © 2016 KaKinChiu. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var overviewLable: UILabel!

    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
