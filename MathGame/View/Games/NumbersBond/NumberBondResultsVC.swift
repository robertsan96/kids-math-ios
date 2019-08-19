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
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var correctsLabel: UILabel!
    @IBOutlet weak var incorrectsLabel: UILabel!
    
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
        
        viewModel?.gamesGenerated.subscribe(onNext: { [weak self] games in
            var corrects: Int = 0
            var incorrects: Int = 0
            guard let vm = self?.viewModel else { return }
            for game in games {
                if vm.isCorrect(game: game) {
                    corrects += 1
                } else {
                    incorrects += 1
                }
            }
            self?.correctsLabel.text = "Corrects: \(corrects)"
            self?.incorrectsLabel.text = "Incorrects: \(incorrects)"
            self?.answersLabel.text = "Answers: \(games.count)"
        }).disposed(by: disposeBag)
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

}
