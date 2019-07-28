//
//  Constants.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

struct Constants {
    
    static let pinLength: Int = 4
    
    struct Colors {
        static let createStudent = UIColor(red: 52/255,
                                           green: 152/255,
                                           blue: 219/255,
                                           alpha: 1)
        static let createStudentLabel = UIColor.white
        static let tableRowStudent = UIColor(red: 52/255,
                                             green: 152/255,
                                             blue: 219/255,
                                             alpha: 1)
        static let tableRowStudentSelected = UIColor(red: 41/255,
                                                     green: 128/255,
                                                     blue: 185/255,
                                                     alpha: 1)
        static let saveStudent = UIColor(red: 46/255,
                                         green: 204/255,
                                         blue: 113/255,
                                         alpha: 1)
    }
    
    enum GameModes {
        case learning, quiz, training
    }
    
    enum GameLevels {
        case beginner, medium, advanced
    }
    
    static let UnknownDefault: Float = -13212
}
