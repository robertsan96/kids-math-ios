//
//  NumberBondResultsVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol NumberBondResultsVCDelegate: class {
    func didDismiss(on vc: NumberBondResultsVC)
}

class NumberBondResultsVC: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var resultsTable: UITableView!
    
    weak var delegate: NumberBondResultsVCDelegate?
    
    var viewModel: NumberBondsResultsVM?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeTable()
    }
    
    func customizeTable() {
    
        resultsTable.register(UINib(nibName: "NumberBondsResultTVC", bundle: nil), forCellReuseIdentifier: "ResultCell")
        resultsTable.rowHeight = 100
        
        viewModel?.gamesGenerated
            .bind(to: resultsTable.rx.items(cellIdentifier: "ResultCell", cellType: NumberBondsResultTVC.self)) { row, model, cell in
                cell.load(with: model)
        }.disposed(by: disposeBag)
    }
    
    func reloadViews() {
        gameName.text = viewModel?.game.getName()
        studentName.text = "Results"
    }

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: false, completion: { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.didDismiss(on: self)
        })
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
