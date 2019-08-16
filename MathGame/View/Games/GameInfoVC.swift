//
//  GameInfoVC.swift
//  MathGame
//
//  Created by Robert Sandru on 8/16/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

class GameInfoVC: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    
    var viewModel: GameInfoVM?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rxStart()
    }

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func updateView(with game: Game) {
        gameName.text = game.getName()
        gameDescription.text = game.getDescription()
    }
    
    func rxStart() {
        viewModel?.game.subscribe(onNext: { [weak self] game in
            self?.updateView(with: game)
        }).disposed(by: disposeBag)
    }
}
