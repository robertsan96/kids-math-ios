//
//  HalvesResultsVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/31/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

protocol HalvesResultsVCDelegate: class {
    func didDismiss(on vc: HalvesResultsVC)
}

class HalvesResultsVC: UIViewController {
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var correctGamesLabel: UILabel!
    @IBOutlet weak var incorrectGamesLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    
    weak var delegate: HalvesResultsVCDelegate?
    
    var viewModel: HalvesResultsVM?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeTable()
    }
    
    func customizeTable() {
        guard let vm = viewModel else { return }
        
        resultsTable.register(UINib(nibName: "HalvesResultTVC", bundle: nil), forCellReuseIdentifier: "ResultCell")
        resultsTable.register(UINib(nibName: "TimedMultiplyingTVC", bundle: nil), forCellReuseIdentifier: "TimedCell")
        resultsTable.rowHeight = 100
        
        switch vm.game {
        case .timedMultiplying:
            viewModel?.timedMultiplyingGames
                .bind(to: resultsTable.rx.items(cellIdentifier: "TimedCell", cellType: TimedMultiplyingTVC.self)) { row, model, cell in
                    cell.load(with: model, for: vm.game)
                }.disposed(by: disposeBag)
            viewModel?.timedMultiplyingGames.subscribe(onNext: { [weak self] games in
                var corrects: Int = 0
                var incorrects: Int = 0
                for game in games {
                    if vm.isTimedCorrect(game: game) {
                        corrects += 1
                    } else {
                        incorrects += 1
                    }
                }
                self?.correctGamesLabel.text = "Corrects: \(corrects)"
                self?.incorrectGamesLabel.text = "Incorrects: \(incorrects)"
                self?.answersCountLabel.text = "Answers: \(games.count)"
            }).disposed(by: disposeBag)
        default:
            viewModel?.gamesGenerated
                .bind(to: resultsTable.rx.items(cellIdentifier: "ResultCell", cellType: HalvesResultTVC.self)) { row, model, cell in
                    cell.load(with: model, for: vm.game)
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
                self?.correctGamesLabel.text = "Corrects: \(corrects)"
                self?.incorrectGamesLabel.text = "Incorrects: \(incorrects)"
                self?.answersCountLabel.text = "Answers: \(games.count)"
            }).disposed(by: disposeBag)
        }
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

