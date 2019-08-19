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
    
    @IBOutlet weak var numberLabel: UILabel!
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
        
        numberLabel.layer.borderWidth = 2
        numberLabel.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func onNumber(_ sender: NumberButton) {
        
        var numbers = numberLabel.text ?? ""
        if numbers.count < 3 {
            let pressedNumber = sender.accessibilityIdentifier ?? ""
            numbers = "\(numbers)\(pressedNumber)"
            numberLabel.text = numbers
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let text = String(numberLabel.text?.dropLast() ?? "")
        numberLabel.text = text
        
    }
    
    @IBAction func onEnter(_ sender: Any) {
        guard let number = Int(numberLabel.text ?? "") else { return }
        delegate?.didPress(number: number)
        numberLabel.text = ""
    }
}
