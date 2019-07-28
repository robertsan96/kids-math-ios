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
    
    @IBOutlet weak var keyboard: NumberKeyboard!
    
    var viewModel: NumbersBondVM?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.delegate = self
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
                if Float(four.numberOne) + Float(number) == Float(four.numberTwo) {
                    print("correct")
                    viewModel?.currentSet.onNext(viewModel?.getSet())
                } else {
                    print("Incorrect")
                }
            }
            if let five = set.gameTypeFive {
                if Float(five.numberOne) + Float(number) == Float(five.numberTwo) {
                    print("Correct")
                    viewModel?.currentSet.onNext(viewModel?.getSet())
                } else {
                    print("Incorrect")
                }
            }
        }
    }
}
