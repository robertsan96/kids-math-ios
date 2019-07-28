//
//  TrainingButton.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class TrainingButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeButton()
    }
    
    func customizeButton() {
        setTitle("Training", for: .normal)
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }

}
