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
    
    init(with game: Game, and bondMode: NumbersBondMode) {
        self.game = game
        self.numbersBondMode = bondMode
    }
}
