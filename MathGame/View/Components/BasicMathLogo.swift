//
//  BasicMathLogo.swift
//  MathGame
//
//  Created by Robert Sandru on 8/2/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class BasicMathLogo: UIView {
    
    @IBOutlet var container: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeContainer()
    }
    
    func customizeContainer() {
        Bundle.main.loadNibNamed("BasicMathLogo", owner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
