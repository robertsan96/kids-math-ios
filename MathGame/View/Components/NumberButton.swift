//
//  NumberButton.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxCocoa

class NumberButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    func customize() {
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.orange.withAlphaComponent(0.68)
        setTitleColor(UIColor.white, for: .normal)
    }
}
