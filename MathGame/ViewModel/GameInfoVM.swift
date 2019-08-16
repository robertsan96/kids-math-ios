//
//  GameInfoVM.swift
//  MathGame
//
//  Created by Robert Sandru on 8/16/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GameInfoVM {
    
    var game: BehaviorRelay<Game>
    
    init(with game: Game) {
        self.game = BehaviorRelay(value: game)
        self.game.accept(game)
    }
}
