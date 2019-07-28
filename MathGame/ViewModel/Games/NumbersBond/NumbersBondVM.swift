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
}

class NumbersBondVM {
    
    var game: Game
    var gameLevel: Constants.GameLevels
    var numbersBondMode: NumbersBondMode
    var student: Student
    
    var currentSet: BehaviorSubject<GameTypeSix?> = BehaviorSubject(value: nil)
    
    var gamesGenerated: [GameTypeSix] = []
    
    init(with game: Game,
         and bondMode: NumbersBondMode,
         and student: Student,
         and gameLevel: Constants.GameLevels) {
        self.game = game
        self.numbersBondMode = bondMode
        self.student = student
        self.gameLevel = gameLevel
        currentSet.onNext(getSet())
    }
    
    func getSet() -> GameTypeSix {
        let setType = Int.random(in: 1 ..< 2)
        
        if setType == 0 {
            var numberOne = Int.random(in: 1 ..< 10)
            var gameTypeFour: GameTypeFour = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: 10)

            while gameWasGeneratedBeforeOne(game: (gameTypeFour: gameTypeFour, nil)) {
                numberOne = Int.random(in: 1 ..< 10)
                gameTypeFour = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: 10)
            }
            let gameType = GameTypeSix(gameTypeFour: gameTypeFour, nil)
            gamesGenerated.append(gameType)
            return gameType
        } else {
            var numberOne = Int.random(in: 1 ..< 10)
            var gameTypeFive: GameTypeFive = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: 10)
            
            while gameWasGeneratedBeforeOne(game: (gameTypeFour: nil, gameTypeFive: gameTypeFive)) {
                numberOne = Int.random(in: 1 ..< 10)
                gameTypeFive = (unknown: Constants.UnknownDefault, operator: "+", numberOne: Float(numberOne), numberTwo: 10)
            }
            let gameType = GameTypeSix(gameTypeFour: nil, gameTypeFive: gameTypeFive)
            gamesGenerated.append(gameType)
            return gameType
        }
        
    }
    
    func gameWasGeneratedBeforeOne(game: GameTypeSix) -> Bool {
        if let lastGame = gamesGenerated.last {
            if let beforeGameTypeFour = lastGame.gameTypeFour {
                if beforeGameTypeFour.numberOne == game.gameTypeFour?.numberOne {
                    return true
                }
                return false
            }
            if let beforeGameTypeFive = lastGame.gameTypeFive {
                if beforeGameTypeFive.numberOne == game.gameTypeFive?.numberOne {
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
}
