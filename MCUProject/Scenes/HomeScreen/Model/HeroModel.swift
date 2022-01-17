//
//  HeroModel.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 15.01.2022.
//

import Foundation



struct HomePageDataModel : Codable{
    var code : Int
    var status : String
    var data : DataModel
    
}

struct DataModel : Codable{
    var results : [HeroModel]
}


struct HeroModel : Codable , Equatable{
    static func == (lhs: HeroModel, rhs: HeroModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id : Int?
    var name : String?
    var thumbnail : ThumbnailModel?
    var description : String?
}

struct ThumbnailModel : Codable{
    var path : String
    var imageExtension : String


    enum CodingKeys : String, CodingKey{
        case path
        case imageExtension = "extension"
    }
}
