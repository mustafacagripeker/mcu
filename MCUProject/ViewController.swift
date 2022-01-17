//
//  ViewController.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 15.01.2022.
//

import UIKit
import Lottie
import SwiftyGif

class ViewController: UIViewController {

    
    @IBOutlet var gifPlayerView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playGif()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController
            guard let navController = vc else{
                return
            }
            self.present(navController , animated: true)
        }
  
    }
    
    
    func playGif(){
        do{
            let gif = try UIImage(gifName: "marvel")
            self.gifPlayerView.setGifImage(gif, loopCount: 5)
        }catch{
            
        }
    }


}

