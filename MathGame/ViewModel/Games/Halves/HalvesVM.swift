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
    var gameLevel: Constants.GameLevels
    var selectedCategory: Int = 1
    
    var student: Student
    
    var currentSet: BehaviorSubject<GameTypeOne?> = BehaviorSubject(value: nil)
    
    var gamesGenerated: [GameTypeOne] = []
    
    init(with game: Game,
         and maxNumber: Int,
         and student: Student,
         and gameLevel: Constants.GameLevels,
         and category: Int = 1) {
        self.game = game
        self.student = student
        self.gameLevel = gameLevel
        self.selectedCategory = category
        currentSet.onNext(getSet())
    }
    
    func getSet() -> GameTypeOne {
        switch game {
        case .halves:
            var numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
            while numberOne%2 != 0 {
                numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
            }
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "+", numberTwo: 2, unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getHalvesInterval().min ..< gameLevel.getHalvesInterval().max)
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
            var numberOne = Int.random(in: gameLevel.getTimesTableInterval().min ..< gameLevel.getTimesTableInterval().max)
            let numberTwo = Int.random(in: gameLevel.getTimesTableInterval().min ..< gameLevel.getTimesTableInterval().max)
            
            var gameTypeOne: GameTypeOne = (numberOne: Float(numberOne), operator: "-", numberTwo: Float(numberTwo), unknown: Constants.UnknownDefault)
            
            while gameWasGeneratedBeforeOne(game: gameTypeOne) {
                numberOne = Int.random(in: gameLevel.getTimesTableInterval().min ..< gameLevel.getTimesTableInterval().max)
                let numberTwo = Int.random(in: gameLevel.getTimesTableInterval().min ..< gameLevel.getTimesTableInterval().max)
                gameTypeOne = (numberOne: Float(numberOne), operator: "-", unknown: Constants.UnknownDefault, numberTwo: Float(numberTwo))
            }
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
}

