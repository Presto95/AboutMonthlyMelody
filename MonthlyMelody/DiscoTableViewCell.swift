//
//  BiographyTableViewCell.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 22..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit

class DiscoTableViewCell: UITableViewCell {

    @IBOutlet weak var albumcover: UIImageView!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
