//
//  GalleryCollectionViewCell.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 23.02.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImageView.contentMode = .scaleAspectFill
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
}
