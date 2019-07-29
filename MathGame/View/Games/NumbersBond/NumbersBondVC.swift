//
//  NumbersBondVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

protocol NumbersBondVCDelegate: class {
    func didDismiss(on vc: NumbersBondVC)
}

class NumbersBondVC: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var mathLabel: UILabel!
    
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var keyboard: NumberKeyboard!
    
    weak var delegate: NumbersBondVCDelegate?
    
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
            mathLabel.text = "How much add \(Int(four.numberOne)) is \(Int(viewModel?.numbersBondMode.getMaxNumber() ?? 0))?"
        }
        if let five = set.gameTypeFive {
            mathLabel.text = "How much add \(Int(five.numberOne)) is \(Int(viewModel?.numbersBondMode.getMaxNumber() ?? 0))?"
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
            if var four = set.gameTypeFour {
                let setNumberOne = Float(four.numberOne)
                let setNumberTwo = Float(four.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne + floatEnteredNumber == setNumberTwo {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                four.unknown = Float(number)
                viewModel?.updateLastSet(with: (gameTypeFour: four, nil))
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            }
            if var five = set.gameTypeFive {
                let setNumberOne = Float(five.numberOne)
                let setNumberTwo = Float(five.numberTwo)
                let floatEnteredNumber = Float(number)
                if setNumberOne + floatEnteredNumber == setNumberTwo {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                five.unknown = Float(number)
                viewModel?.updateLastSet(with: (gameTypeFour: nil, five))
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func answerCorrect() {
        
        view.backgroundColor = UIColor.white
        viewModel?.currentSet.onNext(viewModel?.getSet())
        answerTimer?.invalidate()
        keyboard.isUserInteractionEnabled = true
    }
}

extension NumbersBondVC: TimerViewDelegate {
    
    func timerDidEnd() {
        view.isUserInteractionEnabled = false
        guard let vm = viewModel else { return }
        let numberBondsResultsVC: NumberBondResultsVC = Storyboard.shared.getViewController(by: .numberBondResultsVC)
        let numberBondsResultsVM = NumberBondsResultsVM(with: vm.game, with: vm.student, with: vm.gamesGenerated)
        numberBondsResultsVC.viewModel = numberBondsResultsVM
        numberBondsResultsVC.delegate = self
        present(numberBondsResultsVC, animated: true, completion: {
            numberBondsResultsVC.reloadViews()
        })
    }
}

extension NumbersBondVC: NumberBondResultsVCDelegate {
    
    func didDismiss(on vc: NumberBondResultsVC) {
        self.dismiss(animated: false, completion: { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.didDismiss(on: self)
        })
    }
}
