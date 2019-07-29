//
//  StudentsVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StudentsVC: UIViewController {
    
    @IBOutlet weak var studentsTableView: UITableView!
    @IBOutlet weak var settingsButton: RoundedButton!
    
    var viewModel: StudentsVM = StudentsVM()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.backgroundColor = Constants.Colors.createStudent
        settingsButton.imageView?.tintColor = UIColor.white
        settingsButton.isHidden = viewModel.mode != .normal
        
        customizeTable()
        rxStart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.students.onNext(viewModel.getStudents())
    }
    
    func customizeTable() {
        studentsTableView.register(UINib(nibName: "StudentCellTVC", bundle: nil), forCellReuseIdentifier: "StudentCell")
        studentsTableView.rowHeight = 80
 
        viewModel.students
            .bind(to: studentsTableView
                .rx
                .items(cellIdentifier: "StudentCell", cellType: StudentCellTVC.self)) { [weak self] (row, d, cell) in
                    guard let `self` = self else { return }
                    let student = self.viewModel.getStudentAt(row: row)
                    let fullName = "\(student?.firstName ?? "") \(student?.lastName ?? "")"
                    cell.delegate = self
                    cell.studentName.text = fullName
                    if let lastActivity = student?.lastActivity {
                        cell.lastActivity.text = "Last Activity: \(lastActivity.humanized)"
                    } else {
                        cell.lastActivity.text = "Last Activity: never"
                    }
                    cell.mode = self.viewModel.mode
                    cell.customizeContainer()
                    cell.student = student
                    cell.vcViewModel = self.viewModel
            }.disposed(by: disposeBag)
        
        studentsTableView.rx.modelSelected(Student.self).subscribe(onNext: { [weak self] model in
            
            guard let `self` = self else { return }
            
            if self.viewModel.mode == .normal {
                
                self.promptForPin(for: model)
            }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func onCreateStudent(_ sender: Any) {
        let studentDetailVC: StudentDetailVC = Storyboard.shared.getViewController(by: .studentDetailVC)
        let studentDetailVM: StudentDetailVM = StudentDetailVM(with: .create, and: nil)
        studentDetailVC.viewModel = studentDetailVM
        
        navigationController?.pushViewController(studentDetailVC, animated: true)
    }
    
    @IBAction func onSettings(_ sender: Any) {
        let alertController = UIAlertController(title: "Auth Required",
                                                message: "You must be authenticated in order to be able to open settings.",
                                                preferredStyle: .alert)
        alertController.addTextField { (pinTextField) in
            pinTextField.isSecureTextEntry = true
            pinTextField.keyboardType = .numberPad
        }
        let authAction = UIAlertAction(title: "Login", style: .default) { [weak self] (loginTry) in
            let pinTextField = alertController.textFields?[0]
            guard let pin = pinTextField?.text else {
                return
            }
            let cdh = CoreDataHelper()
            if let masterPin = cdh.getStockValue(for: CoreDataStockKeys.masterPin.rawValue) {
                if pin == masterPin {
                    let settingsVC: SettingsVC = Storyboard.shared.getViewController(by: .settingsVC)
                    let settingsVM: SettingsVM = SettingsVM(mode: .normal)
                    settingsVC.viewModel = settingsVM
                    self?.navigationController?.pushViewController(settingsVC, animated: true)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(authAction)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func promptForPin(for student: Student) {
        let alertVC = UIAlertController(title: "Student's PIN",
                                        message: "In order to access this student, you must provide either a master pin or student pin.",
                                        preferredStyle: .alert)
        
        alertVC.addTextField { (pinTextField) in
            pinTextField.isSecureTextEntry = true
            pinTextField.keyboardType = .numberPad
        }
        
        let login = UIAlertAction(title: "Login", style: .default) { [weak self] (action) in
            if let pinTextField = alertVC.textFields?[0] {
                let cdh = CoreDataHelper()
                let enteredPin = pinTextField.text
                let masterPin = cdh.getStockValue(for: CoreDataStockKeys.masterPin.rawValue)
                let studentPin = "\(Int(student.pin))"
                if enteredPin == studentPin || enteredPin == masterPin {
                    let gamesVC: GamesVC = Storyboard.shared.getViewController(by: .gamesVC)
                    let gamesVM: GamesVM = GamesVM(with: student)
                    gamesVC.viewModel = gamesVM
                    self?.navigationController?.pushViewController(gamesVC, animated: true)
                } else { }
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(login)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true, completion: nil)
    }
}

extension StudentsVC: StudentCellTVCDelegate {
    
    func didPressInfo(on cell: StudentCellTVC, with student: Student) {
        let studentDataVC: StudentDataVC = Storyboard.shared.getViewController(by: .studentDataVC)
        let studentDataVM: StudentDataVM = StudentDataVM(with: student)
        studentDataVC.viewModel = studentDataVM
        navigationController?.pushViewController(studentDataVC, animated: true)
    }
}

extension StudentsVC {
    
    func rxStart() {
        viewModel.students.subscribe(onNext: { [weak self] students in
            self?.studentsTableView.isHidden = students.count == 0
        }).disposed(by: disposeBag)
    }
}

