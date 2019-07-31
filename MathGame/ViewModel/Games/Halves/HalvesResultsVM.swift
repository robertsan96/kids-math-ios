//
//  HalvesResultsVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/31/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

class HalvesResultsVM {
    
    var game: Game
    var student: Student
    var gamesGenerated: BehaviorSubject<[GameTypeOne]>
    
    init(with game: Game,
         with student: Student,
         with results: [GameTypeOne]) {
        let filteredResults = results.filter { gameTypeOne -> Bool in
            return gameTypeOne.unknown != Constants.UnknownDefault
        }
        self.game = game
        self.student = student
        self.gamesGenerated = BehaviorSubject(value: filteredResults)
        storeData()
    }
    
    func getGameGenerated() -> [GameTypeOne] {
        
        do {
            let games = try gamesGenerated.value()
            return games
        } catch {
            return []
        }
    }
    
    func storeData() {
        let cdh = CoreDataHelper()
        let gameSession = cdh.createGameSession(for: student, and: game)
        if let unwrappedGameSession = gameSession {
            for gameGenerated in getGameGenerated() {
                let game = gameGenerated
                let fields = GameSessionLogFields(
                    answer: game.numberOne,
                    correct: isCorrect(game: gameGenerated),
                    date: Date(),
                    question: getQuestion(game: gameGenerated) ?? ""
                )
                let _ = cdh.createGameLog(for: unwrappedGameSession, and: fields)
                
            }
        }
    }
    
    func isCorrect(game: GameTypeOne) -> Bool {
        let numberOne = game.numberOne
        let numberTwo = game.numberTwo
        let unknown = game.unknown
        
        switch self.game {
        case .halves:
            return numberOne / numberTwo == unknown
        case .doubles:
            return numberOne * numberTwo == unknown
        case .adding:
            return numberOne + unknown == numberTwo
        case .takeAways:
            return numberOne - unknown == numberTwo
        case .timesTable:
            return numberOne * numberTwo == unknown
        default:
            return numberOne * numberTwo == unknown
        }
    }
    
    func getQuestion(game: GameTypeOne) -> String? {
        switch self.game {
        case .halves:
            return "\(game.numberOne) / \(game.numberTwo) = \(game.unknown)"
        case .doubles:
            return "\(game.numberOne) * \(game.numberTwo) = \(game.unknown)"
        case .adding:
            return "\(game.numberOne) + \(game.unknown) = \(game.numberTwo)"
        case .takeAways:
            return "\(game.numberOne) - \(game.unknown) = \(game.numberTwo)"
        case .timesTable:
            return "\(game.numberOne) * \(game.numberTwo) = \(game.unknown)"
        default:
            return "\(game.numberOne) * \(game.numberTwo) = \(game.unknown)"
            
        }
    }
}
