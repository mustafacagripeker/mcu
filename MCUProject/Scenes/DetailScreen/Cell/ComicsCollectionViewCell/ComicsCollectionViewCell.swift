//
//  ComicsCollectionViewCell.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 16.01.2022.
//

import UIKit
import SDWebImage

class ComicsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var comicsImageView: UIImageView!
    @IBOutlet var comicsNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func bind(imageUrl : String , name : String){
        comicsImageView.sd_setImage(with: URL(string: imageUrl))
        comicsNameLabel.text = name
    }

}
