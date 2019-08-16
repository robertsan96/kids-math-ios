//
//  StudentDetailVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias StudentDetailVCFields = (
    firstName: String?,
    lastName: String?,
    pin: Float?
)

class StudentDetailVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var confirmPinTextField: UITextField!
    
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: StudentDetailVM?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.backgroundColor = Constants.Colors.saveStudent
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        pinTextField.delegate = self
        confirmPinTextField.delegate = self
        
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        pinTextField.tag = 2
        confirmPinTextField.tag = 3
        
        backButton.setImage(UIImage(named: "arrow_left_black"), for: .highlighted)
        rxStart()
    }
    
    func updateView(to type: StudentDetailVMType) {
        switch type {
        case .create:
            headerLabel.text = "Create Student"
        case .edit:
            let fullName = "\(viewModel?.student?.firstName ?? "") \(viewModel?.student?.lastName ?? "")"
            headerLabel.text = fullName
        }
    }
    
    func updateView(to mode: SettingsVCMode) {
        switch mode {
        case .firstLaunch:
            backButton.isHidden = true
        case .normal: break
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        do {
            let fields = StudentDetailVCFields(
                firstName: firstNameTextField.text,
                lastName: lastNameTextField.text,
                pin: (pinTextField?.text as NSString?)?.floatValue
            )
            guard let type = try viewModel?.type.value() else {
                return
            }
            if type == .create {
                viewModel?.createStudent(with: fields)
            }
            
            let mode = viewModel?.mode.value ?? .normal
            switch mode {
            case .firstLaunch:
                let studentsNVC: StudentsNVC = Storyboard.shared.getViewController(by: .studentsNVC)
                AppDaemon.shared.root(to: studentsNVC)
            case .normal:
                navigationController?.popViewController(animated: true)
                let visibleVC = navigationController?.visibleViewController as? StudentsVC
                visibleVC?.viewModel.students.onNext(visibleVC?.viewModel.getStudents() ?? [])
            }
        } catch {
            return
        }
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension StudentDetailVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentTag = textField.tag
        if currentTag == 0 {
            lastNameTextField.becomeFirstResponder()
        }
        if currentTag == 1 {
            pinTextField.becomeFirstResponder()
        }
        if currentTag == 2 {
            confirmPinTextField.becomeFirstResponder()
        }
        return false
    }
}

extension StudentDetailVC {
    
    func rxStart() {
        
        viewModel?.mode.subscribe(onNext: { [weak self] mode in
            self?.updateView(to: mode)
        }).disposed(by: disposeBag)
        viewModel?.type.subscribe(onNext: { [weak self] type in
            self?.updateView(to: type)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(firstNameTextField.rx.text,
                          lastNameTextField.rx.text,
                          pinTextField.rx.text,
                          confirmPinTextField.rx.text)
            .subscribe(onNext: { [weak self] firstNameValue, lastNameValue, pinTextValue, confirmPinValue in
                
                guard let firstName = firstNameValue,
                    let lastName = lastNameValue,
                    let pinText = pinTextValue,
                    let confirmPin = confirmPinValue else {
                        return
                }
                
                guard firstName.count > 0,
                    lastName.count > 0,
                    pinText.count == 4,
                    pinText == confirmPin else {
                        self?.saveButton.isEnabled = false
                        return
                }
                
                self?.saveButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
}
