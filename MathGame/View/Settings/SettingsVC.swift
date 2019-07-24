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
            default: vc = Storyboard.shared.getViewController(by: .studentDetailVC)
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func onClose(_ sender: Any) {
        let studentsNVC: StudentsNVC = Storyboard.shared.getViewController(by: .studentsNVC)
        AppDaemon.shared.root(to: studentsNVC)
    }
}
