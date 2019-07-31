//
//  HalvesResultTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/31/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class HalvesResultTVC: UITableViewCell {
    
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
    
    func load(with result: GameTypeOne, for game: Game) {
        var correct: Bool = false
        
        let setNumberOne = result.numberOne
        let setNumberTwo = result.numberTwo
        let setUnknown = result.unknown
        
        switch game {
        case .halves:
            questionLabel.text = "\(Int(setNumberOne)) / \(Int(setNumberTwo)) = \(Int(setUnknown))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne / setNumberTwo == setUnknown {
                correct = true
            } else {
                let correctAnswer = setNumberOne / setNumberTwo
                questionLabel.text = "\(Int(setNumberOne)) / \(Int(setNumberTwo)) is not \(Int(setUnknown))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        case .doubles:
            questionLabel.text = "\(Int(setNumberOne)) * \(Int(setNumberTwo)) = \(Int(setUnknown))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne * setNumberTwo == setUnknown {
                correct = true
            } else {
                let correctAnswer = setNumberOne / setNumberTwo
                questionLabel.text = "\(Int(setNumberOne)) * \(Int(setNumberTwo)) is not \(Int(setUnknown))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        case .adding:
            questionLabel.text = "\(Int(setNumberOne)) + \(Int(setUnknown)) = \(Int(setNumberTwo))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne + setUnknown == setNumberTwo {
                correct = true
            } else {
                let correctAnswer = setNumberTwo - setNumberOne
                questionLabel.text = "\(Int(setNumberOne)) + \(Int(setUnknown)) is not \(Int(setNumberTwo))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        case .takeAways:
            questionLabel.text = "\(Int(setNumberOne)) - \(Int(setUnknown)) = \(Int(setNumberTwo))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne - setUnknown == setNumberTwo {
                correct = true
            } else {
                let correctAnswer = setNumberOne - setNumberTwo
                questionLabel.text = "\(Int(setNumberOne)) - \(Int(setUnknown)) is not \(Int(setNumberTwo))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        case .timesTable:
            questionLabel.text = "\(Int(setNumberOne)) * \(Int(setNumberTwo)) = \(Int(setUnknown))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne * setNumberTwo == setUnknown {
                correct = true
            } else {
                let correctAnswer = setNumberOne * setNumberTwo
                questionLabel.text = "\(Int(setNumberOne)) * \(Int(setNumberTwo)) is not \(Int(setUnknown))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        case .dividing:
            questionLabel.text = "\(Int(setNumberOne)) / \(Int(setNumberTwo)) = \(Int(setUnknown))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne / setNumberTwo == setUnknown {
                correct = true
            } else {
                let correctAnswer = setNumberOne / setNumberTwo
                questionLabel.text = "\(Int(setNumberOne)) / \(Int(setNumberTwo)) is not \(Int(setUnknown))"
                answerLabel.text = "Your answer: \(Int(setUnknown)) | Correct answer: \(Int(correctAnswer))"
            }
        default:
            questionLabel.text = "\(Int(setNumberOne)) * \(Int(setNumberTwo)) = \(Int(setUnknown))"
            answerLabel.text = "Your answer: \(Int(setUnknown))"
            if setNumberOne * setNumberTwo == setUnknown {
                correct = true
            } else {
                let correctAnswer = setNumberOne + setNumberTwo
                questionLabel.text = "\(Int(setNumberOne)) * \(Int(setNumberTwo)) is not \(Int(setUnknown))"
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
