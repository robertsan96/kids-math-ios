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
    
    var disposeBag: DisposeBag = DisposeBag()
    var viewModel: StudentDataVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentGameSessionTable.register(UINib(nibName: "GameSessionTVC", bundle: nil), forCellReuseIdentifier: "GameSessionCell")
        studentGameSessionTable.rowHeight = 100
        
        viewModel?.games.bind(to: studentGameSessionTable
            .rx
            .items(cellIdentifier: "GameSessionCell", cellType: GameSessionTVC.self)) { row, model, cell in
                cell.load(with: model)
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadViews()
    }
    
    func reloadViews() {
        guard let student = viewModel?.student else { return }
        let firstName = student.firstName ?? ""
        let lastName = student.lastName ?? ""
        let fullName = firstName + " " + lastName
        studentName.text = fullName
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
