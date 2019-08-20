//
//  NumberBondsResultsVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

class NumberBondsResultsVM {
    
    var game: Game
    var student: Student
    var gamesGenerated: BehaviorSubject<[GameTypeSix]>
    
    init(with game: Game,
         with student: Student,
         with results: [GameTypeSix]) {
        let filteredResults = results.filter { gameTypeSix -> Bool in
            if let four = gameTypeSix.gameTypeFour {
                return four.unknown != Constants.UnknownDefault
            }
            if let five = gameTypeSix.gameTypeFive {
                return five.unknown != Constants.UnknownDefault
            }
            return false
        }
        self.game = game
        self.student = student
        self.gamesGenerated = BehaviorSubject(value: filteredResults)
        storeData()
    }
    
    func getGameGenerated() -> [GameTypeSix] {
        
        do {
            let games = try gamesGenerated.value()
            return games
        } catch {
            return []
        }
    }
    
    func storeData() {
        let cdh = CoreDataHelper()
        let gameSession = cdh.createGameSession(for: student, and: game, and: .beginner)
        if let unwrappedGameSession = gameSession {
            for gameGenerated in getGameGenerated() {
                if let four = gameGenerated.gameTypeFour {
                    let fields = GameSessionLogFields(
                        answer: four.numberOne,
                        correct: isCorrect(game: gameGenerated),
                        date: Date(),
                        question: getQuestion(game: gameGenerated) ?? ""
                    )
                    let _ = cdh.createGameLog(for: unwrappedGameSession, and: fields)
                }
                if let five = gameGenerated.gameTypeFive {
                    let fields = GameSessionLogFields(
                        answer: five.numberOne,
                        correct: isCorrect(game: gameGenerated),
                        date: Date(),
                        question: getQuestion(game: gameGenerated) ?? ""
                    )
                    let _ = cdh.createGameLog(for: unwrappedGameSession, and: fields)
                }
            }
        }
    }
    
    func isCorrect(game: GameTypeSix) -> Bool {
        if let four = game.gameTypeFour {
            let numberOne = four.numberOne
            let numberTwo = four.numberTwo
            let unknown = four.unknown
            
            return numberTwo - numberOne == unknown
        }
        if let five = game.gameTypeFive {
            let numberOne = five.numberOne
            let numberTwo = five.numberTwo
            let unknown = five.unknown
            
            return numberTwo - numberOne == unknown
        }
        return false
    }
    
    func getQuestion(game: GameTypeSix) -> String? {
        if let four = game.gameTypeFour {
            return "\(four.numberOne) + x = \(four.numberTwo)"
        }
        if let five = game.gameTypeFive {
            return "x + \(five.numberOne) = \(five.numberTwo)"
        }
        return nil
    }
}
