//
//  HalvesVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/31/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

class HalvesVM {
    
    var game: Game
    var mode: Constants.GameModes = .quiz
    var gameLevel: Constants.GameLevels
    var selectedCategory: Int = 1
    
    var student: Student
    
    var currentSet: BehaviorSubject<GameTypeOne?> = BehaviorSubject(value: nil)
    var gamesGenerated: [GameTypeOne] = []
    
    var lastGameIndex = 0
    var timedMultiplyingGames: [TimedMultiplying] = []
    var timedMultiplyingGamesDone: [TimedMultiplying] = []
    var currentTimedMultiplyingGame: BehaviorSubject<TimedMultiplying?> = BehaviorSubject(value: nil)
    
    var timedMultiplyingLevel: Int = 0
    var uiTimer: TimerView?
    
    init(with game: Game,
         with mode: Constants.GameModes = .quiz,
         and maxNumber: Int,
         and student: Student,
         and gameLevel: Constants.GameLevels,
         and category: Int = 1,
         and timedMultiplyingLevel: Int = 0) {
        
        self.game = game
        self.mode = mode
        self.student = student
        self.gameLevel = gameLevel
        self.selectedCategory = category
        
        self.timedMultiplyingGames = Constants.GameLevels.beginner.getTimedMultiplyingGames(by: timedMultiplyingLevel)
        self.timedMultiplyingLevel = timedMultiplyingLevel
        setTimedMultiplying()
        
        currentSet.onNext(getSet())
    }
    
    func setTimedMultiplying() {
        if game == .timedMultiplying {
         
            var random: Int = 0
            repeat {
                random = Int.random(in: 0 ..< timedMultiplyingGames.count)
            } while random == lastGameIndex
            lastGameIndex = random
            
            self.currentTimedMultiplyingGame.onNext(timedMultiplyingGames[random])
        }
    }
    
    func doneCurrentTimedMultiplyingGame(with answer: Int) {
        let currentGame: TimedMultiplying?
        do {
            currentGame = try currentTimedMultiplyingGame.value()
        } catch {
            currentGame = nil
        }
        guard var currentGameUw = currentGame else { return }
        
        currentGameUw.userAnswer = answer
        timedMultiplyingGamesDone.append(currentGameUw)
    }
    
    func countCorrectTimedMultiplying() -> Int {
        var corrects = 0
        for answer in timedMultiplyingGamesDone {
            if isTimedCorrect(game: answer) {
                corrects += 1
            }
        }
        return corrects
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
    
    func getSet() -> GameTypeOne {
        switch game {
        case .constrainedAddings:
            var numberOne: Int
            var numberThree: Int
            repeat {
                numberOne = Int.random(in: 2 ..< 10)
                numberThree = Int.random(in: 2 ..< 10)
            } while numberOne + numberThree < 10
            let gameTypeOne = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: Float(numberThree))
            
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
            
        case .halves:
            var numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
            while numberOne%2 != 0 {
                numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
            }
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "+", numberTwo: 2, unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
                while numberOne%2 != 0 {
                    numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
                }
                gameTypeOne = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: 2)
            }
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        case .doubles:
            var numberOne = Int.random(in: gameLevel.getDoublesInterval().min ..< gameLevel.getDoublesInterval().max)
            while numberOne%2 != 0 {
                numberOne = Int.random(in: gameLevel.getDoublesInterval().min ..< gameLevel.getDoublesInterval().max)
            }
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "*", numberTwo: 2, unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getDoublesInterval().min ..< gameLevel.getDoublesInterval().max)
                gameTypeOne = (numberOne: Float(numberOne), operator: "*", unknown: Constants.UnknownDefault, numberTwo: 2)
            }
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        case .adding:
            var numberOne = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
            var numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
            while numberTwo < numberOne {
                numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
            }
            
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "*", numberTwo: Float(numberTwo), unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
                var numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
                while numberTwo < numberOne {
                    numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
                }
                gameTypeOne = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: Float(numberTwo))
            }
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        case .takeAways:
            var numberOne = Int.random(in: gameLevel.getTakeAwaysInterval().min ..< gameLevel.getTakeAwaysInterval().max)
            var numberTwo = Int.random(in: gameLevel.getTakeAwaysInterval().min ..< gameLevel.getTakeAwaysInterval().max)
            while numberTwo > numberOne {
                numberTwo = Int.random(in: gameLevel.getTakeAwaysInterval().min ..< gameLevel.getTakeAwaysInterval().max)
            }
            
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "-", numberTwo: Float(numberTwo), unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getTakeAwaysInterval().min ..< gameLevel.getTakeAwaysInterval().max)
                var numberTwo = Int.random(in: gameLevel.getTakeAwaysInterval().min ..< gameLevel.getTakeAwaysInterval().max)
                while numberTwo > numberOne {
                    numberTwo = Int.random(in: gameLevel.getTakeAwaysInterval().min ..< gameLevel.getTakeAwaysInterval().max)
                }
                gameTypeOne = (numberOne: Float(numberOne), operator: "-", unknown: Constants.UnknownDefault, numberTwo: Float(numberTwo))
            }
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        case .timesTable:
            let numberTwo = selectedCategory
            let numberOne = Int.random(in: gameLevel.getTimesTableInterval().min ..< gameLevel.getTimesTableInterval().max)
            let gameTypeOne = (numberOne: Float(numberOne), operator: "*", unknown: Constants.UnknownDefault, numberTwo: Float(numberTwo))
            
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        case .dividing:
            let numberTwo = selectedCategory
            let numberThree = Int.random(in: gameLevel.getDividingInterval().min ..< gameLevel.getDividingInterval().max)
            let numberOne = numberTwo * numberThree
            let gameTypeOne = (numberOne: Float(numberOne), operator: "/", unknown: Constants.UnknownDefault, numberTwo: Float(numberTwo))

            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        default:
            var numberOne = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
            var numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
            while numberTwo < numberOne {
                numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
            }
            
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "*", numberTwo: Float(numberTwo), unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
                var numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
                while numberTwo < numberOne {
                    numberTwo = Int.random(in: gameLevel.getAddingInterval().min ..< gameLevel.getAddingInterval().max)
                }
                gameTypeOne = (numberOne: Float(numberOne), operator: "+", unknown: Constants.UnknownDefault, numberTwo: Float(numberTwo))
            }
            gamesGenerated.append(gameTypeOne)
            return gameTypeOne
        
        }
    }
    
    func gameWasGeneratedBeforeOne(game: GameTypeOne) -> Bool {
        let numberOne: Float = game.numberOne
        
        if let lastGame = gamesGenerated.last {
            if lastGame.numberOne == numberOne {
                return true
            }
            return false
        }
        return false
    }
    
    func getCurrentSet() -> GameTypeOne? {
        do {
            let set = try self.currentSet.value()
            return set
        } catch {
            return nil
        }
    }
    
    func updateLastSet(with set: GameTypeOne) {
        let allButLast = Array(gamesGenerated.dropLast())
        gamesGenerated = allButLast
        gamesGenerated.append(set)
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
            return numberOne + unknown == numberTwo
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
}

