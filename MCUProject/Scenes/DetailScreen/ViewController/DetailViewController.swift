//
//  DetailViewController.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 16.01.2022.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet var comicsCollectionView: UICollectionView!
    @IBOutlet var returnButton: UIImageView!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var heroDescriptionLabel: UILabel!
    @IBOutlet var noDataLabel: UILabel!
    
    var hero = HeroModel()
    var comicsArray = [ComicsModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        getComics()
        
        
        returnButton.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        
        comicsCollectionView.register(UINib(nibName: "ComicsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ComicsCollectionViewCell")
        comicsCollectionView.delegate = self
        comicsCollectionView.dataSource = self
    }
    
    
    func initView(){
        heroNameLabel.text = hero.name
        heroImageView.sd_setImage(with: URL(string: (hero.thumbnail?.path ?? "") + "." + (hero.thumbnail?.imageExtension ?? "")))
        if hero.description != ""{
            heroDescriptionLabel.text = hero.description
        }else{
            heroDescriptionLabel.text = "No Definition"
        }
    }
    
    func getComics(){
        self.showAnimation()
        HeroService.shared.gerHeroDetail(heroId: self.hero.id ?? 0) { comics, success in
            if success{
                self.comicsArray = comics ?? []
                if comics?.isEmpty == true{
                    self.noDataLabel.isHidden = false
                }
                self.comicsCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.hideAnimation()
                }
            }else{
                self.noDataLabel.isHidden = false
            }
        }
    }
}


extension DetailViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = comicsCollectionView.dequeueReusableCell(withReuseIdentifier: "ComicsCollectionViewCell", for: indexPath) as? ComicsCollectionViewCell else{
            return UICollectionViewCell()
        }
        let comic = comicsArray[indexPath.row]
        cell.bind(imageUrl: "\(comic.thumbnail.path).\(comic.thumbnail.imageExtension)", name: comic.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    
}
