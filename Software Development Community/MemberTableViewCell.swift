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
        memberImageView.layer.cornerRadius = 40
        memberImageView.layer.borderColor = UIColor.black.cgColor
        memberImageView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
