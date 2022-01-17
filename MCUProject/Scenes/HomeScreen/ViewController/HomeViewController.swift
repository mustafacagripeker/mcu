//
//  HomeViewController.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 15.01.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet var heroListCollectionView: UICollectionView!
    
    var heroesArray = [HeroModel]()
    var likedHeroesArray = [HeroModel]()
    var isLoading = false
    var finishPagination = false
    var skip = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedHeroesArray = getLikedHeroes() ?? []
        
        initialSetupCollectionView()
        getHeroes(skip: skip)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likedHeroesArray = getLikedHeroes() ?? []
        heroListCollectionView.reloadData()
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
        likedHeroesArray = getLikedHeroes() ?? []
        if let index = likedHeroesArray.firstIndex(where: {$0.id == hero.id}) {
            likedHeroesArray.remove(at: index)
        }
        let likedData = try! JSONEncoder().encode(likedHeroesArray)
        UserDefaults.standard.set(likedData, forKey: "likedHeroes")
    }
    
    
    func saveLikedHeroes(hero : HeroModel){
        likedHeroesArray = getLikedHeroes() ?? []
        likedHeroesArray.append(hero)
        let likedData = try! JSONEncoder().encode(likedHeroesArray)
        UserDefaults.standard.set(likedData, forKey: "likedHeroes")
    }
    
    func initialSetupCollectionView(){
        heroListCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        heroListCollectionView.delegate = self
        heroListCollectionView.dataSource = self
    }
    
    
    func getHeroes(skip : Int){
        self.showAnimation()
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            HeroService.shared.getHeroList(skip: skip) { heroes, success in
                self.hideAnimation()
                if success{
                    self.heroesArray.append(contentsOf: heroes ?? [])
                    self.heroListCollectionView.reloadData()
                    self.isLoading = false
                }else{
                    self.finishPagination = true
                }
                
            }
        }
    }
}

extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = heroListCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let hero = heroesArray[indexPath.row]
        let imageUrl = hero.thumbnail!.path + "." +  hero.thumbnail!.imageExtension
        cell.bind(imageUrl: imageUrl, characterName: hero.name!)
        if likedHeroesArray.contains(hero){
            cell.likeButton.image = UIImage(named: "like")
        }else{
            cell.likeButton.image = UIImage(named: "unlike")
        }
        cell.likeButton.addTapGesture {
            if cell.likeButton.image == UIImage(named: "like"){
                self.removeLikedHeroes(hero: hero)
                cell.likeButton.image = UIImage(named: "unlike")
            }else{
                self.saveLikedHeroes(hero: hero)
                cell.likeButton.image = UIImage(named: "like")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "DetailStoryboard", bundle: nil).instantiateInitialViewController() as! DetailViewController
        vc.hero = heroesArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 15, height: (collectionView.frame.width / 2) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.heroesArray.count - 1 && !(self.isLoading) && !(self.finishPagination){
            self.skip += 30
            self.getHeroes(skip: skip)
        }
        
    }
    
    
}
