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
    case constrainedAddings
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
        case .numbersBond10: return "Number bonds to 10"
        case .numbersBond20: return "Number bonds to 20"
        case .constrainedAddings: return "Constrained addings"
        case .halves: return "Halves"
        case .doubles: return "Doubles"
        case .adding: return "Adding"
        case .takeAways: return "Take aways"
        case .timesTable: return "Times table"
        case .dividing: return "Dividing"
        case .timedMultiplying: return "Timed multiplying"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .numbersBond10:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed\n\n" +
                
                "In this test the student will learn Number bonds to 10. \n" +
                "He needs to tap correct answer to questions like: " +
                "'How much add 9 is 10?'\n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
            
        case .numbersBond20:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed \n\n" +
                
                "In this test the student will learn Number bonds to 20.\n" +
                "He needs to tap correct answer to questions like: " +
                "'How much add 14 is 20?'\n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds"
            
        case .constrainedAddings:
            return "Learning - in development\n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed \n\n" +
                
                "In this test the student will learn to add 2 numbers (one digit numbers) with answers over 10: \n" +
                "He needs to tap correct answer to questions like: " +
                "'How much is: 7 + 9?' \n\n" +
                
                "This test will help the student to add bigger numbers in the future. \n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
        case .halves:
            return "Learning - in development \n " +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed \n\n" +
                
                "The categories: \n" +
                "Beginner: halves from 0 up to 20 \n" +
                "Medium: halves from 22 up to 50 \n" +
                "Advanced: halves from 52 up to 100 \n\n" +
                
                "In this test the student will learn halves. \n" +
                "He needs to tap correct answer to questions like: \n" +
                "'How much is half of 12?' \n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
            
        case .doubles:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed \n\n" +
                
                "The categories:\n" +
                "Beginner: doubles from 0 up to 10\n" +
                "Medium: doubles from 11 up to 25 \n" +
                "Advanced: doubles from 26 up to 50\n\n" +
                
                "In this test the student will learn doubles: \n" +
                "He needs to tap correct answer to questions like:\n" +
                "'How much is double of 11?' \n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
            
        case .adding:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed\n\n" +
                
                "The categories: \n" +
                "Beginner: adding from 0 up to 10 \n" +
                "Medium: adding from 11 up to 25\n" +
                "Advanced: adding from 26 up to 50 \n\n" +
                
                "In this test the student will learn adding:\n" +
                "He needs to tap correct answer to questions like: \n" +
                "'How much is 15 + 14?'\n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
            
        case .takeAways:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed\n" +
                
                "The categories: \n" +
                "Beginner: take away from 20 down to 0 \n" +
                "Medium: take away from 50 down to 21\n" +
                "Advanced: take away from 100 down to 51\n\n" +
                
                "In this test the student will learn take away: \n" +
                "He needs to tap correct answer to questions like: \n" +
                "'How much is 19 - 11?'\n\n" +
                
            "We can consider that this quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
            
        case .timesTable:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed \n\n" +
                
                
                "In this test the student will learn times tables: \n" +
                "He needs to tap correct answer to questions like: \n" +
                "'How much is 7 * 5?'\n\n" +
                
            "We can consider that the quiz is mastered when the studend can give at least 20 correct answers in 60 seconds."
            
        case .dividing:
            return "Learning - in development \n" +
                "Training - 20 questions with unlimited time to answer \n" +
                "Quiz - 60 seconds timed test to improve speed \n\n" +
                
                
                "In this test the student will learn dividing: \n" +
                "He needs to tap correct answer to questions like: \n" +
                "'How much is 20 / 4?' \n\n" +
                
            "We can consider that the quiz is mastered when the student can give at least 20 correct answers in 60 seconds."
            
        case .timedMultiplying:
            return "Quiz - 60 seconds timed test to improve speed and to learn the tests from every level. \n\n" +
            
            "In this test the student will learn times table in a step by step mode. \n\n" +
            
            "There are 30 steps (levels) for every times table (30 levels for multiplying by 10) (30 levels for multiplying by 2), and so on. \n\n" +
            
            "More numbers will be added with every level the student pass. \n\n" +
            
            "We can consider that a level is mastered when the studend can give at least 20 correct answers in 60 seconds for every level."
        }
    }
}
