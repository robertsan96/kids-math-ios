//
//  Game.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation

typealias GameTypeOne = (numberOne: Float, operator: String, numberTwo: Float, unknown: Float)
typealias GameTypeTwo = (numberTwo: Float, operator: String, numberOne: Float, unknown: Float)
typealias GameTypeThree = (gameTypeOne: GameTypeOne, gameTypeTwo: GameTypeTwo)

typealias GameTypeFour = (numberOne: Float, operator: String, unknown: Float, numberTwo: Float)
typealias GameTypeFive = (unknown: Float, operator: String, numberOne: Float, numberTwo: Float)
typealias GameTypeSix = (gameTypeFour: GameTypeFour?, gameTypeFive: GameTypeFive?)

enum Game {

    case numbersBond10
    case numbersBond20
    case halves
    case doubles
    case adding
    case takeAways
    case timesTable
    case dividing
    case timedMultiplying
    
    func modes() -> [Constants.GameModes] {
        switch self {
        default: return [.quiz]
        }
    }
    
    func getName() -> String {
        switch self {
        case .numbersBond10: return "Number bonds 10"
        case .numbersBond20: return "Number bonds 20"
        case .halves: return "Halves"
        case .doubles: return "Doubles"
        case .adding: return "Adding"
        case .takeAways: return "Take aways"
        case .timesTable: return "Times table"
        case .dividing: return "Dividing"
        case .timedMultiplying: return "Timed multiplying"
        }
    }
}
