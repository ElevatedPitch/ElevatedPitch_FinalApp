//
//  User.swift
//  InternTest
//
//  Created by Rahul Sheth on 1/16/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit

class User: NSObject {
    
    
   
    var occupation = String()
    var previousController = UIViewController()
    var player = AVPlayer()
    var uid: String = ""
    var positionLabel: String = ""
    var companyLabel: String = ""
    var name: String = ""
    var thumbnailImageURL: String = "" 
    var image: UIImage? = nil
    var lastMessage: String = ""
    var profileImageURL: String = ""
    var videoURL: String = ""
    lazy var imageView: UIImageView? = {
        let imageViewer = UIImageView()
        return imageViewer
    }()
    var timeStamp = Double()
    var lastSender: String = ""
    var read: Bool = true
    lazy var cellCheckButton: UIButton? = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleVideo), for: .touchUpInside)
        return button
    }()
    
    lazy var cellPauseButton: UIButton? = {
       let button = UIButton()
        button.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)
        return button
    }()
    
    func pauseVideo() {
        player.pause()
    }
    
    func handleVideo() {
        
        if videoURL != "" {
            let url: URL = URL(string: videoURL)!
            player = AVPlayer(url: (url as URL))
            let playerLayer = AVPlayerLayer(player: player)
            let blackLayer = CALayer()
            blackLayer.backgroundColor = UIColor.black.cgColor
            blackLayer.frame = (imageView?.bounds)!
            playerLayer.frame = (imageView?.bounds)!
            imageView?.layer.addSublayer(blackLayer)
            imageView?.layer.addSublayer(playerLayer)
            playerLayer.masksToBounds = true
            playerLayer.videoRect.equalTo((imageView?.frame)!)
            imageView?.layer.masksToBounds = true
            imageView?.layer.backgroundColor  = UIColor.black.cgColor

            imageView?.contentMode = UIViewContentMode.scaleAspectFill
            player.play()
            
            
            
            
        }
        
    }
}

