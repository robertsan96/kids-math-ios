//
//  TimedMultiplying.swift
//  MathGame
//
//  Created by Robert Sandru on 8/9/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation

enum Operator {
    case plus
    case minus
    case tim
    case div
    
    func getSymbol() -> String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .tim: return "x"
        case .div: return "/"
        }
    }
}

enum UnknownPosition {
    case left
    case right
    case result
}

struct TimedMultiplying {
    
    var left: Float
    var op: Operator
    var right: Float
    var result: Float
    
    var userAnswer: Int?
    
    var uuid = UUID().uuidString
    
    var unknown: UnknownPosition
    
    init(left: Float,
         op: Operator,
         right: Float,
         result: Float,
         unknown: UnknownPosition) {
        self.left = left
        self.op = op
        self.right = right
        self.result = result
        self.unknown = unknown
    }
}
