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
    
    var pinStackViewCircleView: [PinCircleView] = []
    var disposeBag: DisposeBag = DisposeBag()
    
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
            
            guard let pinCircleArray = self?.pinStackViewCircleView, let char = text?.count else {
                return
            }
            for (index, pinCircle) in pinCircleArray.enumerated() {
                
                pinCircle.fill.onNext(false)
                if index <= char-1 {
                    pinCircle.fill.onNext(true)
                }
            }
        }).disposed(by: disposeBag)
    }
}
