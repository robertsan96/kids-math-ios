//
//  NumbersBondVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

enum NumbersBondMode {
    case ten, twenty
    
    func getMaxNumber() -> Float {
        switch self {
        case .ten: return 10
        case .twenty: return 20
        }
    }
}

class NumbersBondVM {
    
    var game: Game
    var mode: Constants.GameModes = .quiz
    var gameLevel: Constants.GameLevels
    var numbersBondMode: NumbersBondMode
    var student: Student
    
    var currentSet: BehaviorSubject<GameTypeSix?> = BehaviorSubject(value: nil)
    
    var gamesGenerated: [GameTypeSix] = []
    
    init(with game: Game,
         with gameMode: Constants.GameModes = .quiz,
         and bondMode: NumbersBondMode,
         and student: Student,
         and gameLevel: Constants.GameLevels) {
        self.game = game
        self.mode = gameMode
        self.numbersBondMode = bondMode
        self.student = student
        self.gameLevel = gameLevel
        currentSet.onNext(getSet())
    }
    
    func getSet() -> GameTypeSix {
        let setType = Int.random(in: 0 ..< 2)
        
        if setType == 0 {
            var numberOne = Int.random(in: 0 ..< Int(numbersBondMode.getMaxNumber()))
            var gameTypeFour: GameTypeFour = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: numbersBondMode.getMaxNumber())

            while gameWasGeneratedBeforeOne(game: (gameTypeFour: gameTypeFour, nil)) {
                numberOne = Int.random(in: 0 ..< Int(numbersBondMode.getMaxNumber()))
                gameTypeFour = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: numbersBondMode.getMaxNumber())
            }
            let gameType = GameTypeSix(gameTypeFour: gameTypeFour, nil)
            gamesGenerated.append(gameType)
            return gameType
        } else {
            var numberOne = Int.random(in: 0 ..< Int(numbersBondMode.getMaxNumber()))
            var gameTypeFive: GameTypeFive = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: numbersBondMode.getMaxNumber())
            
            while gameWasGeneratedBeforeOne(game: (gameTypeFour: nil, gameTypeFive: gameTypeFive)) {
                numberOne = Int.random(in: 0 ..< Int(numbersBondMode.getMaxNumber()))
                gameTypeFive = (unknown: Constants.UnknownDefault, operator: "+", numberOne: Float(numberOne), numberTwo: numbersBondMode.getMaxNumber())
            }
            let gameType = GameTypeSix(gameTypeFour: nil, gameTypeFive: gameTypeFive)
            gamesGenerated.append(gameType)
            return gameType
        }
        
    }
    
    func gameWasGeneratedBeforeOne(game: GameTypeSix) -> Bool {
        var numberOne: Float = Constants.UnknownDefault
        if let gameFour = game.gameTypeFour?.numberOne {
            numberOne = gameFour
        }
        if let gameFive = game.gameTypeFive?.numberOne {
            numberOne = gameFive
        }
        if let lastGame = gamesGenerated.last {
            if let beforeGameTypeFour = lastGame.gameTypeFour {
                if beforeGameTypeFour.numberOne == numberOne {
                    return true
                }
                return false
            }
            if let beforeGameTypeFive = lastGame.gameTypeFive {
                if beforeGameTypeFive.numberOne == numberOne {
                    return true
                }
                return false
            }
        }
        return false
    }
    
    func getCurrentSet() -> GameTypeSix? {
        do {
            let set = try self.currentSet.value()
            return set
        } catch {
            return nil
        }
    }
    
    func updateLastSet(with set: GameTypeSix) {
        let allButLast = Array(gamesGenerated.dropLast())
        gamesGenerated = allButLast
        gamesGenerated.append(set)
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
}
