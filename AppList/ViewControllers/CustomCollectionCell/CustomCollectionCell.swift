//
//  CustomCollectionCell.swift
//  AppList
//
//  Created by iOS on 18/01/23.
//

import UIKit

class CustomCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    static let identifire = "CustomCollectionCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupCelldata(feed: Entry?){
        lblTitle.text = feed?.title?.label
    }
}
