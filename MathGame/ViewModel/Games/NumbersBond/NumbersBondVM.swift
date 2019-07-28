//
//  NumbersBondVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation

enum NumbersBondMode {
    case ten, twenty
}

class NumbersBondVM {
    
    var game: Game
    var numbersBondMode: NumbersBondMode
    var student: Student
    
    init(with game: Game, and bondMode: NumbersBondMode, and student: Student) {
        self.game = game
        self.numbersBondMode = bondMode
        self.student = student
    }
}
