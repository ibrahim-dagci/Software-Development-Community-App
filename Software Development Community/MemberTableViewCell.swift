//
//  MemberTableViewCell.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 29.11.2022.
//

import UIKit



class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userUidLabel: UILabel!
    @IBOutlet weak var memberElo: UILabel!
    @IBOutlet weak var memberAreaLabel: UILabel!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var checkingImageView: UIImageView!
    @IBOutlet weak var memberImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
