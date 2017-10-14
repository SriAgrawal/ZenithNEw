    //
    //  ZNGradientButton.swift
    //  Zenith
    //
    //  Created by Anshu Aggarwal on 05/06/17.
    //  Copyright © 2017 mobiloitte. All rights reserved.
    //
    
    import UIKit
    
    class ZNGradientButton: UIButton {
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            //layoutGradientButtonLayer()
            setTitleColor(.white, for: .normal)
            self.setBackgroundImage(UIImage(named: "btn"), for: .normal)
            self.titleLabel?.font =  UIFont.textDemiFont(fontSize: 22)
            }
        
        func layoutGradientButtonLayer() {
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.frame = self.layer.bounds
            let topColor = UIColor(red:(134/255.0), green:(218/255.0), blue:(253/255.0), alpha: 1.0)
            let bottomColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
