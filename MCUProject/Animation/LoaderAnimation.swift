//
//  LoaderAnimation.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 16.01.2022.
//

import Foundation
import UIKit
import Lottie


fileprivate var mainView : UIView?


extension UIViewController{
    
    func showAnimation(){
        
        mainView = UIView(frame: self.view.bounds)
        
        let animationView = AnimationView(name: "stark")
        animationView.frame = CGRect(x: ((mainView?.frame.width)!)/2-50 , y: ((mainView?.frame.height)!)/2-50, width: 100, height: 100)
        animationView.loopMode = .loop
        animationView.play()
        mainView?.addSubview(animationView)
        
        self.view.addSubview(mainView!)

    }
    
    
    
    func hideAnimation(){
        mainView?.removeFromSuperview()
        mainView = nil
    }
    
}
