//
//  ExerciseConfirmalPopup.swift
//  MathGame
//
//  Created by Robert Sandru on 8/25/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

enum ExerciseConfirmalPopupState {
    case correct, incorrect(butCorrect: Float)
}

class ExerciseConfirmalPopup: UIView {
    
    @IBOutlet weak var stateLabelIcon: UILabel!
    @IBOutlet weak var stateLabelMessage: UILabel!
    @IBOutlet var container: UIView!
    @IBOutlet weak var containerWrapper: UIView!
    
    var state: ExerciseConfirmalPopupState = .correct
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeContainer()
    }
    
    func customizeContainer() {
        Bundle.main.loadNibNamed("ExerciseConfirmalPopup", owner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        containerWrapper.layer.cornerRadius = 15
        containerWrapper.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func set(to state: ExerciseConfirmalPopupState) {
        switch state {
        case .correct:
            stateLabelIcon.text = "✅"
            stateLabelMessage.text = "Correct"
            stateLabelMessage.textColor = .green
        case .incorrect:
            stateLabelIcon.text = "❌"
            stateLabelMessage.text = "Incorrect!"
            stateLabelMessage.textColor = .red
        }
    }
}
