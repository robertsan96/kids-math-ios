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
        
        guard let vm = viewModel else { fatalError() }
        
        keyboard.delegate = self
        timerView.delegate = self
        
        switch vm.mode {
        case .quiz, .learning:
            vm.uiTimer = timerView
        case .training:
            vm.uiTimer = nil
            timerView.isHidden = true
            timerView.timer?.invalidate()
        }
        
        rxStart()
    }
    
    func reloadViews() {
        guard let vm = viewModel else { return }
        gameName.text = vm.game.getName()
        
        switch vm.game {
        case .timedMultiplying:
            studentName.text = "Level \(viewModel?.timedMultiplyingLevel ?? 0)"
        default:
            let firstName = viewModel?.student.firstName ?? ""
            let lastName = viewModel?.student.lastName ?? ""
            let fullName = firstName + " " + lastName
            studentName.text = fullName
        }
    }
    
    func updateView(with set: GameTypeOne) {
        guard let vm = viewModel else { return }
        switch vm.game {
        case .doubles:
            mathLabel.text = "How much is the double of \(Int(set.numberOne))?"
        case .constrainedAddings:
            mathLabel.text = "How much is? \n\(Int(set.numberOne)) + \(Int(set.numberTwo)) = ?"
        case .halves:
            mathLabel.text = "How much is half of \(Int(set.numberOne))?"
        case .adding:
            mathLabel.text = "How much is? \n\(Int(set.numberOne)) + \(Int(set.numberTwo)) = ?"
        case .takeAways:
            mathLabel.text = "How much is? \n\(Int(set.numberOne)) - \(Int(set.numberTwo)) = ?"
        case .timesTable:
            mathLabel.text = "How much is? \n\(Int(set.numberOne)) * \(Int(set.numberTwo)) = ?"
        case .dividing:
            mathLabel.text = "What's is \(Int(set.numberOne)) / \(Int(set.numberTwo))?"
            
        default: break
        }
        //        mathLabel.text = "How much is the half of \(Int(set.numberOne))?"
    }
    
    func updateView(withTimed set: TimedMultiplying) {
        let unknownPosition = set.unknown
        let left = Int(set.left)
        let right = Int(set.right)
        let result = Int(set.result)
        
        switch unknownPosition {
        case .left:
            mathLabel.text = "? \(set.op.getSymbol()) \(right) = \(result)"
        case .right:
            mathLabel.text = "\(left) \(set.op.getSymbol()) ? = \(result)"
        case .result:
            mathLabel.text = "\(left) \(set.op.getSymbol()) \(right)"
        }
    }
}

extension GenericGameOne {
    
    func rxStart() {
        
        guard let vm = viewModel else { return }
        
        if vm.game != .timedMultiplying {
            viewModel?.currentSet.subscribe(onNext: { [weak self] set in
                guard let set = set else { return }
                self?.updateView(with: set)
            }).disposed(by: disposeBag)
        } else {
            viewModel?.currentTimedMultiplyingGame.subscribe(onNext: { [weak self] set in
                guard let set = set else { return }
                self?.updateView(withTimed: set)
            }).disposed(by: disposeBag)
        }
    }
}

extension GenericGameOne: NumberKeyboardDelegate {
    
    func didPress(number: Int) {
        guard let vm = viewModel else { return }
        
        if var set = viewModel?.getCurrentSet() {
            
            switch vm.game {
            case .halves:
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .doubles:
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .adding:
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .takeAways:
            
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
                
            case .timesTable:
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .dividing:
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
            case .timedMultiplying:
                viewModel?.doneCurrentTimedMultiplyingGame(with: number)
                viewModel?.setTimedMultiplying()
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
                
            default:
                set.unknown = Float(number)
                viewModel?.updateLastSet(with: set)
                keyboard.isUserInteractionEnabled = false
                answerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(answerCorrect), userInfo: nil, repeats: false)
                
            }
        }
    }
    
    @objc func answerCorrect() {
        viewModel?.currentSet.onNext(viewModel?.getSet())
        answerTimer?.invalidate()
        keyboard.isUserInteractionEnabled = true
        
        guard let vm = viewModel else { return }
        
        switch vm.mode {
        case .quiz, .learning: break
        case .training:
            var corrects: Int = 0
            for game in vm.gamesGenerated {
                if vm.isCorrect(game: game) {
                    corrects += 1
                }
            }
            if corrects == 20 {
                let halvesResultsVC: HalvesResultsVC = Storyboard.shared.getViewController(by: .halvesResultsVC)
                let halvesResultsVM = HalvesResultsVM(with: vm.game, with: vm.student, with: vm.gamesGenerated)
                halvesResultsVC.viewModel = halvesResultsVM
                halvesResultsVC.delegate = self
                present(halvesResultsVC, animated: true, completion: {
                    halvesResultsVC.reloadViews()
                })
            }
        }
    }
}

extension GenericGameOne: TimerViewDelegate {
    
    func timerDidEnd() {
        view.isUserInteractionEnabled = false
        guard let vm = viewModel else { return }
        
        switch vm.game {
        case .timedMultiplying:
            let halvesResultsVC: HalvesResultsVC = Storyboard.shared.getViewController(by: .halvesResultsVC)
            let halvesResultsVM = HalvesResultsVM(with: vm.game, with: vm.student, with: vm.gamesGenerated, with: vm.timedMultiplyingGamesDone, with: vm.timedMultiplyingLevel)
            halvesResultsVC.viewModel = halvesResultsVM
            halvesResultsVC.delegate = self
            present(halvesResultsVC, animated: true, completion: {
                halvesResultsVC.reloadViews()
            })
        default:
            let halvesResultsVC: HalvesResultsVC = Storyboard.shared.getViewController(by: .halvesResultsVC)
            let halvesResultsVM = HalvesResultsVM(with: vm.game, with: vm.student, with: vm.gamesGenerated)
            halvesResultsVC.viewModel = halvesResultsVM
            halvesResultsVC.delegate = self
            present(halvesResultsVC, animated: true, completion: {
                halvesResultsVC.reloadViews()
            })
        }
    }
}

extension GenericGameOne: HalvesResultsVCDelegate {
    func didDismiss(on vc: HalvesResultsVC) {
        dismiss(animated: true, completion: nil)
    }
}
