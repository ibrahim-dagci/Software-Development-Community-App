//
//  TableViewCellPostwithComments1.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.09.2023.
//

import UIKit

class TableViewCellPostwithComments1: UITableViewCell {

    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var dayCounterLabel: UILabel!
    @IBOutlet weak var rootNameLabel: UILabel!
    @IBOutlet weak var rootImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
