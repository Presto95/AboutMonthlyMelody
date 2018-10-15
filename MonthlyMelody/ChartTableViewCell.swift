//
//  ChartTableViewCell.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 22..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit

class ChartTableViewCell: UITableViewCell {

    @IBOutlet weak var albumcover: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
