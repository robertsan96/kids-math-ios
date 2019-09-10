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
    var gameMode: Constants.GameModes?
    var gameLevel: Constants.GameLevels?
    var student: Student
    var gamesGenerated: BehaviorSubject<[GameTypeOne]>
    
    var currentTimedMultiplyingLevel: Int = 0
    var timedMultiplyingGames: BehaviorSubject<[TimedMultiplying]> = BehaviorSubject(value: [])
    
    init(with game: Game,
         with gameMode: Constants.GameModes? = .quiz,
         with gameLevel: Constants.GameLevels? = nil,
         with student: Student,
         with results: [GameTypeOne],
         with timedResults: [TimedMultiplying] = [],
         with timedMultiplyingLevel: Int = 0) {
        let filteredResults = results.filter { gameTypeOne -> Bool in
            return gameTypeOne.unknown != Constants.UnknownDefault
        }
        self.game = game
        self.gameLevel = gameLevel
        self.student = student
        self.gamesGenerated = BehaviorSubject(value: filteredResults)
        self.timedMultiplyingGames.onNext(timedResults)
        self.currentTimedMultiplyingLevel = timedMultiplyingLevel
        
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
    
    func getTimedGameGenerated() -> [TimedMultiplying] {
        
        do {
            let games = try timedMultiplyingGames.value()
            return games
        } catch {
            return []
        }
    }
    
    func storeData() {
        let cdh = CoreDataHelper()
        let gameSession: GameSession?
        if game == .timedMultiplying {
            if countCorrectTimedMultiplying() >= 20 {
                gameSession = cdh.createGameSession(for: student,
                                                    and: game,
                                                    with: gameMode ?? .quiz,
                                                    and: gameLevel ?? .beginner,
                                                    and: String(currentTimedMultiplyingLevel))
                if let unwrappedGameSession = gameSession {
                    for gameGenerated in getTimedGameGenerated() {
                        let game = gameGenerated
                        let fields = GameSessionLogFields(
                            answer: Float(game.userAnswer ?? 0) ,
                            correct: isTimedCorrect(game: gameGenerated),
                            date: Date(),
                            question: getTimedQuestion(game: gameGenerated) ?? ""
                        )
                        let _ = cdh.createGameLog(for: unwrappedGameSession, and: fields)
                        
                    }
                }
            }
        } else {
            gameSession = cdh.createGameSession(for: student, and: game, and: gameLevel ?? .beginner)
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
    }
    
    func countCorrectTimedMultiplying() -> Int {
        var corrects = 0
        for answer in try! timedMultiplyingGames.value() {
            if isTimedCorrect(game: answer) {
                corrects += 1
            }
        }
        return corrects
    }
    
    func isCorrect(game: GameTypeOne) -> Bool {
        let numberOne = game.numberOne
        let numberTwo = game.numberTwo
        let unknown = game.unknown
        
        switch self.game {
        case .halves:
            return numberOne / numberTwo == unknown
        case .constrainedAddings:
            return numberOne + numberTwo == unknown
        case .doubles:
            return numberOne * numberTwo == unknown
        case .adding:
            return numberOne + numberTwo == unknown
        case .takeAways:
            return numberOne - unknown == numberTwo
        case .timesTable:
            return numberOne * numberTwo == unknown
        case .dividing:
            return numberOne / numberTwo == unknown
        default:
            return numberOne * numberTwo == unknown
        }
    }
    
    func timedIsFullyCorrect() -> Bool {
        var correct = true
        var games: [TimedMultiplying] = []
        do {
            games = try timedMultiplyingGames.value()
        } catch { return false }
        for game in games {
            var gameIsCorrect = false
            let left = Int(game.left)
            let right = Int(game.right)
            let operationResult = Int(game.result)
            let userInput = game.userAnswer ?? 0
            
            switch game.unknown {
            case .left:
                gameIsCorrect = left == userInput
            case .right:
                gameIsCorrect = right == userInput
            case .result:
                gameIsCorrect = operationResult == userInput
            }
            
            if gameIsCorrect == false {
                correct = false
                break
            }
        }
        
        return correct
    }
    
    func isTimedCorrect(game: TimedMultiplying) -> Bool {
        var correct = true
        var gameIsCorrect = false
        let left = Int(game.left)
        let right = Int(game.right)
        let operationResult = Int(game.result)
        let userInput = game.userAnswer ?? 0
        
        switch game.unknown {
        case .left:
            gameIsCorrect = left == userInput
        case .right:
            gameIsCorrect = right == userInput
        case .result:
            gameIsCorrect = operationResult == userInput
        }
        
        if gameIsCorrect == false {
            correct = false
        }
        
        return correct
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
        case .dividing:
            return "\(game.numberOne) / \(game.numberTwo) = \(game.unknown)"
        default:
            return "\(game.numberOne) * \(game.numberTwo) = \(game.unknown)"
            
        }
    }
    
    func getTimedQuestion(game: TimedMultiplying) -> String? {
        let left = Int(game.left)
        let right = Int(game.right)
        let operationResult = Int(game.result)
        
        return "\(left) \(game.op.getSymbol()) \(right) = \(operationResult)"
    }
}
