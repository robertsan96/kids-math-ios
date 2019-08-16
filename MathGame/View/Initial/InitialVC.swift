//
//  InitialVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InitialVC: UIViewController {

    @IBOutlet weak var pinStackView: UIStackView!
    @IBOutlet weak var pinInputTextField: UITextField!
    @IBOutlet weak var pinHintLabel: UILabel!
    
    var pinStackViewCircleView: [PinCircleView] = []
    var disposeBag: DisposeBag = DisposeBag()
    
    var pinRedirectTimer: Timer?
    var viewModel: InitialVM = InitialVM()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizePinStackView()
        
        pinInputTextField.becomeFirstResponder()
        pinInputTextField.keyboardType = .numberPad
        pinInputTextField.delegate = self

        rxStart()
    }

    func customizePinStackView() {
        pinStackView.distribution = .fillProportionally
        pinStackView.alignment = .fill
        for _ in 1...Constants.pinLength {
            let pinCircleView = PinCircleView()
            pinStackView.addArrangedSubview(pinCircleView)
            pinStackViewCircleView.append(pinCircleView)
        }
    }
}

extension InitialVC {
    
    func updateView(to step: InitialPinSetStep) {
        switch step {
        case .setPin:
            pinHintLabel.text = "First things first. Let's set up a new master pin."
        case .confirmPin:
            pinHintLabel.text = "Good. Do it again so we're sure it's ok."
        }
    }
    
    func updateStep(to step: InitialPinSetStep) {
        if step == .confirmPin {
            pinInputTextField.text = ""
        }
        viewModel.pinStep.onNext(step)
    }
    
    func didFillPinInputs() {
        
        if viewModel.pin[.setPin] == viewModel.pin[.confirmPin] {
            for pinCircle in pinStackViewCircleView {
                pinCircle.state.onNext(.success)
            }
            pinHintLabel.text = "Perfect. ✅"
            pinRedirectTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(pinSuccess), userInfo: nil, repeats: false)
        } else {
            for pinCircle in pinStackViewCircleView {
                pinCircle.state.onNext(.error)
            }
            pinHintLabel.text = "Oops! Please try again and add the initial PIN."
            pinRedirectTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(resetPinInputs), userInfo: nil, repeats: false)
        }
    }
    
    @objc func resetPinInputs() {
        pinInputTextField.text = ""
        pinInputTextField.insertText("")
        viewModel.pinStep.onNext(.setPin)
        viewModel.pin[.setPin] = ""
        viewModel.pin[.confirmPin] = ""
        for pinCircle in pinStackViewCircleView {
            pinCircle.state.onNext(.normal)
            pinCircle.fill.onNext(false)
        }
    }
    
    @objc func pinSuccess() {
        let cdHelper = CoreDataHelper()
        cdHelper.createOrUpdateStockValue(for: .firstLaunch, value: "false")
        cdHelper.createOrUpdateStockValue(for: .masterPin, value: pinInputTextField.text ?? "")

        let studentsCreate: StudentDetailVC = Storyboard.shared.getViewController(by: .studentDetailVC)
        let studentsCreateVM = StudentDetailVM(with: .create, and: nil)
        studentsCreate.viewModel = studentsCreateVM
        
        let nav = UINavigationController(rootViewController: studentsCreate)
        nav.navigationBar.isHidden = true
        AppDaemon.shared.root(to: nav)
    }
}

extension InitialVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= Constants.pinLength
    }
}

extension InitialVC {
    
    func rxStart() {
        pinInputTextField.rx.text.asObservable().subscribe(onNext: { [weak self] text in
            
            guard let pinCircleArray = self?.pinStackViewCircleView,
                let char = text?.count,
                let `self` = self,
                let unwrappedText = text else {
                return
            }
            if char == Constants.pinLength {
                do {
                    let step = try self.viewModel.pinStep.value()
                    if step == .setPin {
                        self.updateStep(to: .confirmPin)
                        self.viewModel.pin[.setPin] = unwrappedText
                        for pinCircle in pinCircleArray {
                            pinCircle.fill.onNext(false)
                        }
                    } else {
                        self.viewModel.pin[.confirmPin] = unwrappedText
                        for pinCircle in pinCircleArray {
                            pinCircle.fill.onNext(true)
                        }
                        self.didFillPinInputs()
                    }
                } catch {
                    return
                }
            } else {
                for (index, pinCircle) in pinCircleArray.enumerated() {
                    
                    pinCircle.fill.onNext(false)
                    if index <= char-1 {
                        pinCircle.fill.onNext(true)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.pinStep.subscribe(onNext: { [weak self] pinStep in
            self?.updateView(to: pinStep)
        }).disposed(by: disposeBag)
    }
}
