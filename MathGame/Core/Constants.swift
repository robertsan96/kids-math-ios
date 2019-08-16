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
            case .beginner: return (1, 12)
            case .medium: return (12, 20)
            case .advanced: return (20,30)
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
        
        func getTimedMultiplyingGames(by level: Int) -> [TimedMultiplying] {
            switch level {
            case 1:
                return [
                    TimedMultiplying(left: 1, op: .tim, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 2, op: .tim, right: 10, result: 20, unknown: .result),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .result),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .result)
                ]
            case 2:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 2, result: 20, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 3, result: 30, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 4, result: 40, unknown: .result)
                ]
            case 3:
                return [
                    TimedMultiplying(left: 1, op: .tim, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 2, op: .tim, right: 10, result: 20, unknown: .result),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .result),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 2, result: 20, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 3, result: 30, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 4, result: 40, unknown: .result)
                ]
            case 4:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 1, result: 10, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 2, result: 20, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 3, result: 30, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 4, result: 40, unknown: .right)
                ]
            case 5:
                return [
                    TimedMultiplying(left: 1, op: .tim, right: 10, result: 10, unknown: .left),
                    TimedMultiplying(left: 2, op: .tim, right: 10, result: 20, unknown: .left),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .left),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .left)
                ]
            case 6:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 1, result: 10, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 2, result: 20, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 3, result: 30, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 4, result: 40, unknown: .right),
                    TimedMultiplying(left: 1, op: .tim, right: 10, result: 10, unknown: .left),
                    TimedMultiplying(left: 2, op: .tim, right: 10, result: 20, unknown: .left),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .left),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .left)
                ]
            case 7:
                return [
                    TimedMultiplying(left: 10, op: .div, right: 10, result: 1, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 10, result: 2, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 10, result: 3, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 10, result: 4, unknown: .result)
                ]
            case 8:
                return [
                    TimedMultiplying(left: 10, op: .div, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 2, result: 10, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 3, result: 10, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 4, result: 10, unknown: .result)
                ]
            case 9:
                return [
                    TimedMultiplying(left: 10, op: .div, right: 10, result: 1, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 10, result: 2, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 10, result: 3, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 10, result: 4, unknown: .result),
                    TimedMultiplying(left: 10, op: .div, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 2, result: 10, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 3, result: 10, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 4, result: 10, unknown: .result)
                ]
            case 10:
                return [
                    TimedMultiplying(left: 5, op: .tim, right: 10, result: 50, unknown: .result),
                    TimedMultiplying(left: 6, op: .tim, right: 10, result: 60, unknown: .result),
                    TimedMultiplying(left: 7, op: .tim, right: 10, result: 70, unknown: .result),
                    TimedMultiplying(left: 8, op: .tim, right: 10, result: 80, unknown: .result)
                ]
            case 11:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 5, result: 50, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 6, result: 60, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 7, result: 70, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 8, result: 80, unknown: .result)
                ]
            case 13:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 5, result: 50, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 6, result: 60, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 7, result: 70, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 8, result: 80, unknown: .right),
                ]
            case 14:
                return [
                    TimedMultiplying(left: 5, op: .tim, right: 10, result: 50, unknown: .left),
                    TimedMultiplying(left: 6, op: .tim, right: 10, result: 60, unknown: .left),
                    TimedMultiplying(left: 7, op: .tim, right: 10, result: 70, unknown: .left),
                    TimedMultiplying(left: 8, op: .tim, right: 10, result: 80, unknown: .left),
                ]
            case 15:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 5, result: 50, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 6, result: 60, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 7, result: 70, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 8, result: 80, unknown: .right),
                    TimedMultiplying(left: 5, op: .tim, right: 10, result: 50, unknown: .left),
                    TimedMultiplying(left: 6, op: .tim, right: 10, result: 60, unknown: .left),
                    TimedMultiplying(left: 7, op: .tim, right: 10, result: 70, unknown: .left),
                    TimedMultiplying(left: 8, op: .tim, right: 10, result: 80, unknown: .left)
                ]
            case 16:
                return [
                    TimedMultiplying(left: 50, op: .div, right: 10, result: 5, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 10, result: 6, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 10, result: 7, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 10, result: 8, unknown: .result),
                ]
            case 17:
                return [
                    TimedMultiplying(left: 50, op: .div, right: 5, result: 10, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 6, result: 10, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 7, result: 10, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 8, result: 10, unknown: .result)
                ]
            case 18:
                return [
                    TimedMultiplying(left: 50, op: .div, right: 10, result: 5, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 10, result: 6, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 10, result: 7, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 10, result: 8, unknown: .result),
                    TimedMultiplying(left: 50, op: .div, right: 5, result: 10, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 6, result: 10, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 7, result: 10, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 8, result: 10, unknown: .result)
                ]
            case 19:
                return [
                    TimedMultiplying(left: 9, op: .tim, right: 10, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 11, op: .tim, right: 10, result: 110, unknown: .result),
                    TimedMultiplying(left: 12, op: .tim, right: 10, result: 120, unknown: .result),
                ]
            case 20:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 9, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 11, result: 110, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 12, result: 120, unknown: .result),
                ]
            case 21:
                return [
                    TimedMultiplying(left: 9, op: .tim, right: 10, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 11, op: .tim, right: 10, result: 110, unknown: .result),
                    TimedMultiplying(left: 12, op: .tim, right: 10, result: 120, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 9, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 11, result: 110, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 12, result: 120, unknown: .result),
                ]
            case 22:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 9, result: 90, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 11, result: 110, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 12, result: 120, unknown: .right),
                ]
            case 23:
                return [
                    TimedMultiplying(left: 9, op: .tim, right: 10, result: 90, unknown: .left),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .left),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .left),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .left)
                ]
            case 24:
                return [
                    TimedMultiplying(left: 10, op: .tim, right: 9, result: 90, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 11, result: 110, unknown: .right),
                    TimedMultiplying(left: 10, op: .tim, right: 12, result: 120, unknown: .right),
                    TimedMultiplying(left: 9, op: .tim, right: 10, result: 90, unknown: .left),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .left),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .left),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .left)
                ]
            case 25:
                return [
                    TimedMultiplying(left: 90, op: .div, right: 10, result: 9, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 10, result: 11, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 10, result: 12, unknown: .result),
                ]
            case 26:
                return [
                    TimedMultiplying(left: 90, op: .div, right: 9, result: 10, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 11, result: 10, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 12, result: 10, unknown: .result),
                ]
            case 27:
                return [
                    TimedMultiplying(left: 90, op: .div, right: 10, result: 9, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 10, result: 11, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 10, result: 12, unknown: .result),
                    TimedMultiplying(left: 90, op: .div, right: 9, result: 10, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 11, result: 10, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 12, result: 10, unknown: .result)
                ]
            case 28:
                return [
                    TimedMultiplying(left: 1, op: .tim, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 2, op: .tim, right: 10, result: 20, unknown: .result),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .result),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .result),
                    TimedMultiplying(left: 5, op: .tim, right: 10, result: 50, unknown: .result),
                    TimedMultiplying(left: 6, op: .tim, right: 10, result: 60, unknown: .result),
                    TimedMultiplying(left: 7, op: .tim, right: 10, result: 70, unknown: .result),
                    TimedMultiplying(left: 8, op: .tim, right: 10, result: 80, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .tim, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 2, result: 20, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 3, result: 30, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 4, result: 40, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 5, result: 50, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 6, result: 60, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 7, result: 70, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 8, result: 80, unknown: .result),
                    
                    TimedMultiplying(left: 9, op: .tim, right: 10, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 11, op: .tim, right: 10, result: 110, unknown: .result),
                    TimedMultiplying(left: 12, op: .tim, right: 10, result: 120, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .tim, right: 9, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 11, result: 110, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 12, result: 120, unknown: .result)
                ]
            case 29:
                return [
                    TimedMultiplying(left: 10, op: .div, right: 10, result: 1, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 10, result: 2, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 10, result: 3, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 10, result: 4, unknown: .result),
                    TimedMultiplying(left: 50, op: .div, right: 10, result: 5, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 10, result: 6, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 10, result: 7, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 10, result: 8, unknown: .result),
                    
                    TimedMultiplying(left: 90, op: .div, right: 10, result: 9, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 10, result: 11, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 10, result: 12, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .div, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 2, result: 10, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 3, result: 10, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 4, result: 10, unknown: .result),
                    
                    TimedMultiplying(left: 50, op: .div, right: 5, result: 10, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 6, result: 10, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 7, result: 10, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 8, result: 10, unknown: .result),
                    TimedMultiplying(left: 90, op: .div, right: 9, result: 10, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 11, result: 10, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 12, result: 10, unknown: .result)
                ]
            case 30:
                return [
                    TimedMultiplying(left: 1, op: .tim, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 2, op: .tim, right: 10, result: 20, unknown: .result),
                    TimedMultiplying(left: 3, op: .tim, right: 10, result: 30, unknown: .result),
                    TimedMultiplying(left: 4, op: .tim, right: 10, result: 40, unknown: .result),
                    TimedMultiplying(left: 5, op: .tim, right: 10, result: 50, unknown: .result),
                    TimedMultiplying(left: 6, op: .tim, right: 10, result: 60, unknown: .result),
                    TimedMultiplying(left: 7, op: .tim, right: 10, result: 70, unknown: .result),
                    TimedMultiplying(left: 8, op: .tim, right: 10, result: 80, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .tim, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 2, result: 20, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 3, result: 30, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 4, result: 40, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 5, result: 50, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 6, result: 60, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 7, result: 70, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 8, result: 80, unknown: .result),
                    
                    TimedMultiplying(left: 9, op: .tim, right: 10, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 11, op: .tim, right: 10, result: 110, unknown: .result),
                    TimedMultiplying(left: 12, op: .tim, right: 10, result: 120, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .tim, right: 9, result: 90, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 10, result: 100, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 11, result: 110, unknown: .result),
                    TimedMultiplying(left: 10, op: .tim, right: 12, result: 120, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .div, right: 10, result: 1, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 10, result: 2, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 10, result: 3, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 10, result: 4, unknown: .result),
                    TimedMultiplying(left: 50, op: .div, right: 10, result: 5, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 10, result: 6, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 10, result: 7, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 10, result: 8, unknown: .result),
                    
                    TimedMultiplying(left: 90, op: .div, right: 10, result: 9, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 10, result: 11, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 10, result: 12, unknown: .result),
                    
                    TimedMultiplying(left: 10, op: .div, right: 1, result: 10, unknown: .result),
                    TimedMultiplying(left: 20, op: .div, right: 2, result: 10, unknown: .result),
                    TimedMultiplying(left: 30, op: .div, right: 3, result: 10, unknown: .result),
                    TimedMultiplying(left: 40, op: .div, right: 4, result: 10, unknown: .result),
                    
                    TimedMultiplying(left: 50, op: .div, right: 5, result: 10, unknown: .result),
                    TimedMultiplying(left: 60, op: .div, right: 6, result: 10, unknown: .result),
                    TimedMultiplying(left: 70, op: .div, right: 7, result: 10, unknown: .result),
                    TimedMultiplying(left: 80, op: .div, right: 8, result: 10, unknown: .result),
                    TimedMultiplying(left: 90, op: .div, right: 9, result: 10, unknown: .result),
                    TimedMultiplying(left: 100, op: .div, right: 10, result: 10, unknown: .result),
                    TimedMultiplying(left: 110, op: .div, right: 11, result: 10, unknown: .result),
                    TimedMultiplying(left: 120, op: .div, right: 12, result: 10, unknown: .result)
                ]
            default: break
            }
            return []
        }
    }
    
    static let UnknownDefault: Float = -13212
}
