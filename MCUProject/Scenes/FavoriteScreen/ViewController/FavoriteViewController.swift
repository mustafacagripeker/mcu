//
//  FavoriteViewController.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 16.01.2022.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet var favoriteCollectionViewCell: UICollectionView!
    
    
    var heroes = [HeroModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heroes = getLikedHeroes() ?? []
        favoriteCollectionViewCell.reloadData()
        
        
        favoriteCollectionViewCell.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        favoriteCollectionViewCell.delegate = self
        favoriteCollectionViewCell.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        heroes = getLikedHeroes() ?? []
        favoriteCollectionViewCell.reloadData()
    }
    
    func getLikedHeroes() -> [HeroModel]?{
        let likedHeroes = UserDefaults.standard.data(forKey: "likedHeroes")
        if likedHeroes != nil{
            let likedHeroArray = try! JSONDecoder().decode([HeroModel].self, from: likedHeroes!)
            return likedHeroArray
        }
        return nil
    }
    
    func removeLikedHeroes(hero : HeroModel){
        heroes = getLikedHeroes() ?? []
        if let index = heroes.firstIndex(where: {$0.id == hero.id}) {
            heroes.remove(at: index)
        }
        let likedData = try! JSONEncoder().encode(heroes)
        UserDefaults.standard.set(likedData, forKey: "likedHeroes")
    }
    
    
    func saveLikedHeroes(hero : HeroModel){
        heroes = getLikedHeroes() ?? []
        heroes.append(hero)
        let likedData = try! JSONEncoder().encode(heroes)
        UserDefaults.standard.set(likedData, forKey: "likedHeroes")
    }
    
}

extension FavoriteViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteCollectionViewCell.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bind(imageUrl: "\(self.heroes[indexPath.row].thumbnail?.path ?? "").\(self.heroes[indexPath.row].thumbnail?.imageExtension ?? "")", characterName: self.heroes[indexPath.row].name ?? "")
        cell.likeButton.image = UIImage(named: "like")
        cell.likeButton.addTapGesture {
            if cell.likeButton.image == UIImage(named: "like"){
                self.removeLikedHeroes(hero: self.heroes[indexPath.row])
                cell.likeButton.image = UIImage(named: "unlike")
                self.heroes = self.getLikedHeroes() ?? []
                self.favoriteCollectionViewCell.reloadData()
                
            }else{
                self.saveLikedHeroes(hero: self.heroes[indexPath.row])
                cell.likeButton.image = UIImage(named: "like")
            }
        }
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 15, height: (collectionView.frame.width / 2) - 5)
    }
}
