//
//  NumberKeyboard.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

protocol NumberKeyboardDelegate:class {
    func didPress(number: Int)
}

class NumberKeyboard: UIView {

    @IBOutlet var containerView: UIView!
    weak var delegate: NumberKeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeContainer()
    }

    func customizeContainer() {
        Bundle.main.loadNibNamed("NumberKeyboard", owner: self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func onNumber(_ sender: NumberButton) {
        if let number = Int(sender.accessibilityIdentifier ?? "0") {
            delegate?.didPress(number: number)
        }
    }
}
