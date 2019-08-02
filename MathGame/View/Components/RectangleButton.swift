//
//  RectangleButton.swift
//  MathGame
//
//  Created by Robert Sandru on 8/2/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class RectangleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    func customize() {
        layer.cornerRadius = 10
        let blackImage = UIImage(named: "black")?.withRenderingMode(.alwaysTemplate)
        
        setBackgroundImage(blackImage, for: .disabled)
        
    }

}
