//
//  CharacterCollectionViewCell.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 15.01.2022.
//

import UIKit
import SDWebImage

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var characterNameLabel: UILabel!
    @IBOutlet var likeButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    func bind(imageUrl : String , characterName : String){
        
        characterNameLabel.text = characterName
        characterImageView.sd_setImage(with: URL(string: imageUrl))
        
    }

}
