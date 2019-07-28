//
//  NumbersBondVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

class NumbersBondVC: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var mathLabel: UILabel!
    
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var keyboard: NumberKeyboard!
    
    var answerTimer: Timer?
    var viewModel: NumbersBondVM?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.delegate = self
        timerView.delegate = self
        rxStart()
    }
    
    func reloadViews() {
        guard let vm = viewModel else { return }
        gameName.text = vm.game.getName()
        
        let firstName = viewModel?.student.firstName ?? ""
        let lastName = viewModel?.student.lastName ?? ""
        let fullName = firstName + " " + lastName
        studentName.text = fullName
    }
    
    func updateView(with set: GameTypeSix) {
        if let four = set.gameTypeFour {
            mathLabel.text = "How much add \(Int(four.numberOne)) is 10?"
        }
        if let five = set.gameTypeFive {
            mathLabel.text = "How much add \(Int(five.numberOne)) is 10?"
        }
    }
}

extension NumbersBondVC {
    
    func rxStart() {
        viewModel?.currentSet.subscribe(onNext: { [weak self] set in
            guard let set = set else { return }
            self?.updateView(with: set)
        }).disposed(by: disposeBag)
    }
}

extension NumbersBondVC: NumberKeyboardDelegate {
    func didPress(number: Int) {
        if let set = viewModel?.getCurrentSet() {
            if let four = set.gameTypeFour {
                let setNumberOne = Float(four.numberOne)
                let setNumberTwo = Float(four.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne + floatEnteredNumber == setNumberTwo {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                keyboard.isUserInteractionEnabled = false
                timerView.disableTimer()
                answerTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            }
            if let five = set.gameTypeFive {
                let setNumberOne = Float(five.numberOne)
                let setNumberTwo = Float(five.numberTwo)
                let floatEnteredNumber = Float(number)
                if setNumberOne + floatEnteredNumber == setNumberTwo {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                keyboard.isUserInteractionEnabled = false
                timerView.disableTimer()
                answerTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func answerCorrect() {
        
        view.backgroundColor = UIColor.white
        viewModel?.currentSet.onNext(viewModel?.getSet())
        answerTimer?.invalidate()
        timerView.startTimer()
        keyboard.isUserInteractionEnabled = true
    }
}

extension NumbersBondVC: TimerViewDelegate {
    
    func timerDidEnd() {
        view.isUserInteractionEnabled = false
    }
}
