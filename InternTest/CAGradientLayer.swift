//
//  CAGradientLayer.swift
//  InternU
//
//  Created by Rahul Sheth on 10/27/16.
//  Copyright © 2016 Rahul Sheth. All rights reserved.
//

import UIKit


//This gives the blue background color that is used for all the pages. If you choose to add a new view Controller and want this background, use this code: 
// let background = CAGradientLayer()
//background.backgroundColor = CAGradientLayer().turquoiseColor()
//background.frame = self.view.bounds
//self.view.layer.insertSublayer(background, at: 0)


extension CAGradientLayer {
    func turquoiseColor() -> CGColor {
////        let topColor = UIColor(red: (0/255.0), green: (206/255.0), blue: (209/255.0), alpha: 1 )
//        let bottomColor = UIColor(red: (180/255.0), green: (220/255.0), blue: (209/255.0), alpha: 1 )
//        let topColor = UIColor(red: (0/255.0), green: (204/255.0), blue: (255/255.0), alpha: 1 )
//        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
//
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        
//        gradientLayer.colors = gradientColors
//        
//        gradientLayer.locations = gradientLocations as [NSNumber]?
//        
//        return gradientLayer as! CGColor
        return UIColor.blue.cgColor
    }

}
