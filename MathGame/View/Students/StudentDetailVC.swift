//
//  StudentDetailVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

typealias StudentDetailVCFields = (
    firstName: String?,
    lastName: String?,
    pin: Float?
)

class StudentDetailVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var pinLabel: UITextField!
    
    @IBOutlet weak var saveButton: RoundedButton!
    
    var viewModel: StudentDetailVM?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.backgroundColor = Constants.Colors.saveStudent
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
    
    @IBAction func onSave(_ sender: Any) {
        do {
            let fields = StudentDetailVCFields(
                firstName: firstName.text,
                lastName: lastNameLabel.text,
                pin: (pinLabel?.text as NSString?)?.floatValue
            )
            guard let type = try viewModel?.type.value() else {
                return
            }
            if type == .create {
                viewModel?.createStudent(with: fields)
            }
            
            navigationController?.popViewController(animated: true)
            let visibleVC = navigationController?.visibleViewController as? StudentsVC
            visibleVC?.viewModel.students.onNext(visibleVC?.viewModel.getStudents() ?? [])
        } catch {
            return
        }
    }
}

extension StudentDetailVC {
    
    func rxStart() {
        viewModel?.type.subscribe(onNext: { [weak self] type in
            self?.updateView(to: type)
        }).disposed(by: disposeBag)
    }
}
