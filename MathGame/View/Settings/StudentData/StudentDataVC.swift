//
//  StudentDataVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/29/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StudentDataVC: UIViewController {

    @IBOutlet weak var studentGameSessionTable: UITableView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var noReportsLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!

    var disposeBag: DisposeBag = DisposeBag()
    var viewModel: StudentDataVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentGameSessionTable.register(UINib(nibName: "GameSessionTVC", bundle: nil), forCellReuseIdentifier: "GameSessionCell")
        studentGameSessionTable.rowHeight = 100
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        dateTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        viewModel?.games.bind(to: studentGameSessionTable
            .rx
            .items(cellIdentifier: "GameSessionCell", cellType: GameSessionTVC.self)) { row, model, cell in
                cell.load(with: model)
        }.disposed(by: disposeBag)
        
        viewModel?.games.subscribe(onNext: { [weak self] games in
            self?.noReportsLabel.isHidden = games.count > 0
        }).disposed(by: disposeBag)
        
        viewModel?.date.subscribe(onNext: { [weak self] date in
            self?.viewModel?.setGamesFor(date: date)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            self?.dateTextField.text = dateFormatter.string(from: date)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadViews()
    }
    
    @IBAction func onBackgroundTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadViews() {
        guard let student = viewModel?.student else { return }
        let firstName = student.firstName ?? ""
        let lastName = student.lastName ?? ""
        let fullName = firstName + " " + lastName
        studentName.text = fullName
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
        
        viewModel?.date.accept(sender.date)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
