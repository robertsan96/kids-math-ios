//
//  EnterButton.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class EnterButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    func customize() {
        layer.cornerRadius = 5
        backgroundColor = UIColor.green.withAlphaComponent(1)
        setTitleColor(UIColor.white, for: .normal)
    }
}
