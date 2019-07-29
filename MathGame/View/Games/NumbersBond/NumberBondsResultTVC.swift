//
//  NumberBondsResultTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class NumberBondsResultTVC: UITableViewCell {

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
    
    func load(with result: GameTypeSix) {
        var correct: Bool = false
        
        if let four = result.gameTypeFour {
            let setNumberOne = four.numberOne
            let setNumberTwo = four.numberTwo
            let setUnknown = four.unknown
            
            questionLabel.text = "\(Int(setNumberOne)) + \(Int(setUnknown)) = \(Int(setNumberTwo))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            
            if setUnknown + setNumberOne == setNumberTwo {
                correct = true
            } else {
                let correctAnswer = setNumberTwo - setNumberOne
                questionLabel.text = "\(Int(setNumberOne)) + \(Int(setUnknown)) is not \(Int(setNumberTwo))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        }
        if let five = result.gameTypeFive {
            let setNumberOne = five.numberOne
            let setNumberTwo = five.numberTwo
            let setUnknown = five.unknown
            
            questionLabel.text = "\(Int(setNumberOne)) + \(Int(setUnknown)) = \(Int(setNumberTwo))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            
            if setUnknown + setNumberOne == setNumberTwo {
                correct = true
            } else {
                let correctAnswer = setNumberTwo - setNumberOne
                questionLabel.text = "\(Int(setNumberOne)) + \(Int(setUnknown)) is not \(Int(setNumberTwo))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        }
        
        if correct {
            cellBackgroundView.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        } else {
            cellBackgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        }
    }
}
