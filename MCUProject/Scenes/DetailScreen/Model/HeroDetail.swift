//
//  HeroDetail.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 16.01.2022.
//

import Foundation


struct DetailResponseModel : Codable{
    var code : Int
    var status : String
    var data : DetailDataModel
}

struct DetailDataModel : Codable{
    var results : [ComicsModel]
}


struct ComicsModel : Codable{
    var id : Int
    var title : String
    var thumbnail : ThumbnailModel
}
