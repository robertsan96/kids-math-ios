//
//  TimedMultiplyingTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 8/9/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class TimedMultiplyingTVC: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        cellBackgroundView.layer.cornerRadius = 25
    }
    
    func load(with result: TimedMultiplying, for game: Game) {
        var correct: Bool = false
        
        let left = Int(result.left)
        let right = Int(result.right)
        let operationResult = Int(result.result)
        let userInput = result.userAnswer ?? 0
        
        switch result.unknown {
        case .left:
            questionLabel.text = "? \(result.op.getSymbol()) \(right) = \(operationResult)"
            answerLabel.text = "Your answer: \(userInput)"
            
            correct = left == userInput
        case .right:
            questionLabel.text = "\(left) \(result.op.getSymbol()) ? = \(operationResult)"
            answerLabel.text = "Your answer: \(userInput)"
    
            correct = right == userInput
        case .result:
            questionLabel.text = "\(left) \(result.op.getSymbol()) \(right) = \(operationResult)"
            answerLabel.text = "Your answer: \(userInput)"
            
            correct = operationResult == userInput
        }
    
        if correct {
            cellBackgroundView.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        } else {
            cellBackgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        }
    }
    
}
