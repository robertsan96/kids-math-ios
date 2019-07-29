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
    }
}
