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
        static let tableRowStudent = UIColor(red: 49/255,
                                             green: 104/255,
                                             blue: 204/255,
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
    
    enum GameLevels: Int {
        case beginner, medium, advanced
        
        func getHalvesInterval() -> (min: Int, max: Int) {
            switch self {
            case .beginner: return (0, 20)
            case .medium: return (20, 50)
            case .advanced: return (50,100)
            }
        }
        
        func getDoublesInterval() -> (min: Int, max: Int) {
            switch self {
            case .beginner: return (0, 20)
            case .medium: return (20, 50)
            case .advanced: return (50,100)
            }
        }
        
        func getAddingInterval() -> (min: Int, max: Int) {
            switch self {
            case .beginner: return (0, 20)
            case .medium: return (20, 50)
            case .advanced: return (50,100)
            }
        }
        
        func getTakeAwaysInterval() -> (min: Int, max: Int) {
            switch self {
            case .beginner: return (0, 20)
            case .medium: return (20, 50)
            case .advanced: return (50,100)
            }
        }
        
        func getTimesTableInterval() -> (min: Int, max: Int) {
            switch self {
            case .beginner: return (0, 10)
            case .medium: return (10, 20)
            case .advanced: return (20,50)
            }
        }
        
        func getDividingInterval() -> (min: Int, max: Int) {
            switch self {
            case .beginner: return (1, 12)
            case .medium: return (10, 20)
            case .advanced: return (20,50)
            }
        }
        
        func getDividingCategory() -> ClosedRange<Int> {
            switch self {
            case .beginner: return 1...12
            case .medium: return 12...20
            case .advanced: return 20...30
            }
        }
        
        func getCategory(by row: Int) -> Int {
            switch self {
            case .beginner:
                let categories: [Int] = Array(getDividingCategory())
                return categories[row]
            case .medium:
                let categories: [Int] = Array(getDividingCategory())
                return categories[row]
            case .advanced:
                let categories: [Int] = Array(getDividingCategory())
                return categories[row]
            }
        }
        
        static func getLevel(by id: Int) -> GameLevels {
            switch id {
            case 0: return GameLevels.beginner
            case 1: return GameLevels.medium
            case 2: return GameLevels.advanced
            default: return GameLevels.beginner
            }
        }
    }
    
    static let UnknownDefault: Float = -13212
}
