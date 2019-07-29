//
//  GameSessionTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/29/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class GameSessionTVC: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gameCorrects: UILabel!
    @IBOutlet weak var gameIncorrects: UILabel!
    
    var game: GameSession?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeContainer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            container.backgroundColor = Constants.Colors.tableRowStudentSelected
        } else {
            
            container.backgroundColor = Constants.Colors.tableRowStudent
        }
    }
    
    func customizeContainer() {
        
        container.layer.cornerRadius = 15
    }
    
    func load(with game: GameSession) {
        gameNameLabel.text = game.game
        gameDateLabel.text = game.date?.humanized
        
        let allLogs = (game.logs?.allObjects as? [GameLog])
        let corrects = allLogs?.filter({ (gameLog) -> Bool in
            return gameLog.correct == true
        })
        gameCorrects.text = "Correct: \(corrects?.count ?? 0)"
        let allLogsCount = allLogs?.count ?? 0
        let correctsCount = corrects?.count ?? 0
        gameIncorrects.text = "Incorrect: \(allLogsCount - correctsCount)"
        
    }
    
}
