//
//  HeroService.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 15.01.2022.
//

import Foundation
import Alamofire
import CryptoKit

class HeroService{
    
    static var shared : HeroService{
        return HeroService()
    }
    fileprivate init(){}
    
    
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    func getHeroList(skip : Int ,completion : @escaping ([HeroModel]? , Bool)-> Void ){
        
        let timestamp = NSDate().timeIntervalSince1970
        let secretKey = "7f4f6fc1ffb1b28e952bd5963cfe7431ffdb125e"
        let publicKey = "d1cd8ee4e244d5573ad0c04fcabab64b"
        let hash = MD5(string: "\(timestamp)\(secretKey)\(publicKey)")
        
        var params = [String:Any]()
        params["apikey"] = "d1cd8ee4e244d5573ad0c04fcabab64b"
        params["ts"] = timestamp
        params["hash"] = hash
        params["offset"] = skip
        params["limit"] = 30
        
        AF.request("https://gateway.marvel.com:443/v1/public/characters?",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString).responseJSON { response in
            
            if response.data != nil && response.error == nil{
                guard let data = response.value as? [String:Any] else{
                    completion(nil,false)
                    return
                }
                do{
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = try decoder.decode(HomePageDataModel.self, from: json)
                    let heroes = data.data.results
                    completion(heroes , true)
                    
                }catch{
                    completion(nil,true)
                }
            }
        }
    }
    
    
    func gerHeroDetail(heroId : Int , completion : @escaping ([ComicsModel]? , Bool)->Void){
        let timestamp = NSDate().timeIntervalSince1970
        let secretKey = "7f4f6fc1ffb1b28e952bd5963cfe7431ffdb125e"
        let publicKey = "d1cd8ee4e244d5573ad0c04fcabab64b"
        let hash = MD5(string: "\(timestamp)\(secretKey)\(publicKey)")
        
        
        var params = [String:Any]()
        params["apikey"] = "d1cd8ee4e244d5573ad0c04fcabab64b"
        params["ts"] = timestamp
        params["hash"] = hash
        params["limit"] = 10
        params["format"] = "comic"
        params["dateRange"] = "2005-01-01,2022-01-01"
        params["orderBy"] = "-focDate"
        
        AF.request("https://gateway.marvel.com:443/v1/public/characters/\(heroId)/comics?",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString).responseJSON { response in
            
            if response.data != nil && response.error == nil{
                guard let data = response.value as? [String:Any] else{
                    completion(nil,false)
                    return
                }
                do{
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = try decoder.decode(DetailResponseModel.self, from: json)
                    let comics = data.data.results
                    completion(comics , true)
                    
                }catch{
                    completion(nil,true)
                }
            }
        }
        
        
    }
    
    
    
    
    
}

