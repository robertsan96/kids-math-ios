//
//  SettingsVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsVC: UIViewController {

    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var closeButton: RoundedButton!
    var viewModel: SettingsVM = SettingsVM(mode: .normal)
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.isHidden = viewModel.mode == .normal
        
        customizeTable()
    }

    func customizeTable() {
        optionsTableView.register(UINib(nibName: "SettingsTVC", bundle: nil), forCellReuseIdentifier: "OptionCell")
        optionsTableView.rowHeight = 70
        
        viewModel.options.bind(to: optionsTableView
            .rx
            .items(cellIdentifier: "OptionCell", cellType: SettingsTVC.self)) { (row, model, cell) in
                cell.optionName.text = model.getTitle()
                cell.container.backgroundColor = model.getContainerColor()
        }.disposed(by: disposeBag)
        
        optionsTableView.rx.modelSelected(SettingsOptions.self).subscribe(onNext: { [weak self] model in
            let vc: UIViewController
            switch model {
            case .addStudent:
                let studentDetailVC: StudentDetailVC = Storyboard.shared.getViewController(by: .studentDetailVC)
                let studentDetailVM: StudentDetailVM = StudentDetailVM(with: .create, and: nil)
                studentDetailVC.viewModel = studentDetailVM
                vc = studentDetailVC
            case .deleteStudent:
                let studentsVC: StudentsVC = Storyboard.shared.getViewController(by: .studentsVC)
                let studentsVM: StudentsVM = StudentsVM(with: .delete)
                studentsVC.viewModel = studentsVM
                vc = studentsVC
            case .resetStudent:
                let studentsVC: StudentsVC = Storyboard.shared.getViewController(by: .studentsVC)
                let studentsVM: StudentsVM = StudentsVM(with: .reset)
                studentsVC.viewModel = studentsVM
                vc = studentsVC
            default:
                vc = Storyboard.shared.getViewController(by: .studentDetailVC)
                let alert = UIAlertController(title: "Update",
                                              message: "You're going to update your masterpin. Insert a new pin.",
                                              preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (oldPin) in
                    oldPin.isSecureTextEntry = true
                    oldPin.placeholder = "Old Pin"
                    oldPin.keyboardType = .numberPad
                })
                alert.addTextField(configurationHandler: { (new) in
                    new.isSecureTextEntry = true
                    new.placeholder = "New Pin"
                    new.keyboardType = .numberPad
                })
                alert.addTextField(configurationHandler: { (confirm) in
                    confirm.isSecureTextEntry = true
                    confirm.placeholder = "Old Pin"
                    confirm.keyboardType = .numberPad
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let change = UIAlertAction(title: "Change", style: .destructive, handler: { (action) in
                    let old = alert.textFields?[0]
                    let new = alert.textFields?[1]
                    let confirm = alert.textFields?[2]
                    
                    guard let oldPin = old?.text, let newPin = new?.text, let confirmPin = confirm?.text else { return }
                    
                    let cdh = CoreDataHelper()
                    
                    guard let savedOldPin = cdh.getStockValue(for: CoreDataStockKeys.masterPin.rawValue) else { return }
                    
                    if savedOldPin == oldPin {
                        if newPin == confirmPin {
                            cdh.createOrUpdateStockValue(for: .masterPin, value: newPin)
                        }
                    }
                    
                })
                
                alert.addAction(cancel)
                alert.addAction(change)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func onClose(_ sender: Any) {
        let studentsNVC: StudentsNVC = Storyboard.shared.getViewController(by: .studentsNVC)
        AppDaemon.shared.root(to: studentsNVC)
    }
}
