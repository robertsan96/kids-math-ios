//
//  SelectModeView.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxCocoa

protocol SelectModeViewDelegate {
    func didSelect(mode: Constants.GameModes, for game: Game)
}

class SelectModeView: UIView {
    
    @IBOutlet weak var closeButton: RoundedButton!
    @IBOutlet weak var modeView: UIView!
    @IBOutlet var containerView: UIView!
    
//    @IBOutlet weak var learningButton: LearningButton!
    @IBOutlet weak var trainingButton: TrainingButton!
    @IBOutlet weak var quizButton: QuizButton!
    @IBOutlet weak var gameName: UILabel!
    
    var game: Game?
    
    var delegate: SelectModeViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeContainer()
    }
    
    func customizeContainer() {
        Bundle.main.loadNibNamed("SelectModeView", owner: self, options: nil)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        modeView.layer.borderWidth = 5
        modeView.layer.borderColor = UIColor.black.cgColor
        addSubview(containerView)
    }
    
    func load(with game: Game) {
        self.game = game
        self.gameName.text = game.getName()
//        learningButton.isUserInteractionEnabled = false
//        learningButton.alpha = 0.3
        trainingButton.isUserInteractionEnabled = false
        trainingButton.alpha = 0.3
        quizButton.isUserInteractionEnabled = false
        quizButton.alpha = 0.3
        
        if game.modes().contains(.learning) {
//            learningButton.isUserInteractionEnabled = true
//            learningButton.alpha = 1
        }
        if game.modes().contains(.training) {
            trainingButton.isUserInteractionEnabled = true
            trainingButton.alpha = 1
        }
        if game.modes().contains(.quiz) {
            quizButton.isUserInteractionEnabled = true
            quizButton.alpha = 1
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func onLearning(_ sender: Any) {
        guard let game = game else { return }
        self.delegate?.didSelect(mode: .learning, for: game)
    }
    @IBAction func onTraining(_ sender: Any) {
        guard let game = game else { return }
        self.delegate?.didSelect(mode: .training, for: game)
    }
    @IBAction func onQuiz(_ sender: Any) {
        guard let game = game else { return }
        self.delegate?.didSelect(mode: .quiz, for: game)
    }
    
}
