//
//  HalvesVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/31/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

protocol HalvesVCDelegate: class {
    func didDismiss(on vc: NumbersBondVC)
}

class GenericGameOne: UIViewController {
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var mathLabel: UILabel!
    
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var keyboard: NumberKeyboard!
    
    weak var delegate: HalvesVCDelegate?
    
    var answerTimer: Timer?
    var viewModel: HalvesVM?
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
    
    func updateView(with set: GameTypeOne) {
        guard let vm = viewModel else { return }
        switch vm.game {
        case .doubles:
            mathLabel.text = "How much is the double of \(Int(set.numberOne))?"
        case .halves:
            mathLabel.text = "How much is the half of \(Int(set.numberOne))?"
        case .adding:
            mathLabel.text = "What's the number? \(Int(set.numberOne)) + X = \(Int(set.numberTwo))?"
        case .takeAways:
            mathLabel.text = "What's the number? \(Int(set.numberOne)) - X = \(Int(set.numberTwo))?"
        case .timesTable:
            mathLabel.text = "What's is \(Int(set.numberOne)) * \(Int(set.numberTwo))?"
        case .dividing:
            mathLabel.text = "What's is \(Int(set.numberOne)) / \(Int(set.numberTwo))?"
            
        default: break
        }
//        mathLabel.text = "How much is the half of \(Int(set.numberOne))?"
    }
}

extension GenericGameOne {
    
    func rxStart() {
        viewModel?.currentSet.subscribe(onNext: { [weak self] set in
            guard let set = set else { return }
            self?.updateView(with: set)
        }).disposed(by: disposeBag)
    }
}

extension GenericGameOne: NumberKeyboardDelegate {
    
    func didPress(number: Int) {
        guard let vm = viewModel else { return }

        if var set = viewModel?.getCurrentSet() {
            
            switch vm.game {
            case .halves:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne / setNumberTwo == floatEnteredNumber {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .doubles:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne * setNumberTwo == floatEnteredNumber {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .adding:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne + floatEnteredNumber == setNumberTwo {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .takeAways:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne - floatEnteredNumber == setNumberTwo {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
                
            case .timesTable:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne * setNumberTwo == floatEnteredNumber {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .dividing:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne / setNumberTwo == floatEnteredNumber {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
                
            default:
                let setNumberOne = Float(set.numberOne)
                let setNumberTwo = Float(set.numberTwo)
                let floatEnteredNumber = Float(number)
                
                if setNumberOne + setNumberTwo == floatEnteredNumber {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.red
                }
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
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

extension GenericGameOne: TimerViewDelegate {
    
    func timerDidEnd() {
        view.isUserInteractionEnabled = false
        guard let vm = viewModel else { return }
        let halvesResultsVC: HalvesResultsVC = Storyboard.shared.getViewController(by: .halvesResultsVC)
        let halvesResultsVM = HalvesResultsVM(with: vm.game, with: vm.student, with: vm.gamesGenerated)
        halvesResultsVC.viewModel = halvesResultsVM
        halvesResultsVC.delegate = self
        present(halvesResultsVC, animated: true, completion: {
            halvesResultsVC.reloadViews()
        })
    }
}

extension GenericGameOne: HalvesResultsVCDelegate {
    func didDismiss(on vc: HalvesResultsVC) {
        dismiss(animated: true, completion: nil)
    }
}
