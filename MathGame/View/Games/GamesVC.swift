//
//  GamesVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GamesVC: UIViewController {

    @IBOutlet weak var gamesTable: UITableView!
    @IBOutlet weak var studentLabel: UILabel!
    
    var viewModel: GamesVM?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var selectModeOverlay: UIView?
    var selectModeView: SelectModeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeTable()
        rxStart()
    }
    
    func customizeTable() {
        gamesTable.register(UINib(nibName: "GameTVC", bundle: nil), forCellReuseIdentifier: "GameCell")
        gamesTable.rowHeight = 100
        
        viewModel?.games.bind(to: gamesTable
            .rx.items(cellIdentifier: "GameCell", cellType: GameTVC.self)) { row, model, cell in
                cell.gameName.text = model.getName()
        }.disposed(by: disposeBag)
        
        gamesTable.rx.modelSelected(Game.self).subscribe(onNext: { [weak self] game in
            guard let `self` = self else { return }
            self.selectModeView?.removeFromSuperview()
            self.selectModeOverlay?.removeFromSuperview()
            let selectMode = SelectModeView()
            selectMode.load(with: game)
            selectMode.frame = CGRect(x: 0, y: self.view.frame.height-400, width: self.view.frame.width, height: 400)
            selectMode.closeButton.addTarget(self, action: #selector(self.didCloseModeSelector), for: .touchUpInside)
            selectMode.delegate = self
            self.selectModeView = selectMode
            
            let overlay: UIView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.view.frame.width,
                                                       height: self.view.frame.height))
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlay.addSubview(selectMode)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didCloseModeSelector))
            overlay.addGestureRecognizer(tapGesture)
            self.selectModeOverlay = overlay
            self.view.addSubview(overlay)
        }).disposed(by: disposeBag)
    }
    
    @objc func didCloseModeSelector() {
        self.selectModeOverlay?.removeFromSuperview()
        self.selectModeView?.removeFromSuperview()
    }
    
    func updateView(with student: Student) {
        let firstName = student.firstName ?? ""
        let lastName = student.lastName ?? ""
        let fullName = firstName + " " + lastName
        studentLabel.text = fullName
    }
}

extension GamesVC {
    
    func rxStart() {
        viewModel?
            .student
            .subscribe(onNext: { [weak self] student in
                self?.updateView(with: student)
            })
            .disposed(by: disposeBag)
    }
}

extension GamesVC: SelectModeViewDelegate {
    
    func didSelect(mode: Constants.GameModes, for game: Game) {
        switch mode {
        case .quiz:
            break
        case .learning: break
        case .training: break
        }
    }
}
