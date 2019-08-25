//
//  TimedMultiplyingManager.swift
//  MathGame
//
//  Created by Robert Sandru on 8/25/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import SwiftCSV

class TimedMultiplyingManager {
    
    static var shared: TimedMultiplyingManager = TimedMultiplyingManager()
    let csv: CSV
    
    private init() {
        let bundleURL = Bundle.main.bundleURL
        let csvURL = bundleURL.appendingPathComponent("multiplying_330_levels.csv")
        
        do {
            self.csv = try CSV(url: csvURL)
        } catch {
            fatalError("Problem loading CSV")
        }
    }
    
    func getLevels() -> Int {
        return csv.enumeratedRows.count
    }
    
    func getLevel(level: Int) -> [TimedMultiplying] {
        
        let levelRow = csv.enumeratedRows.filter { (row) -> Bool in
            return String(level) == row[0]
        }.first
        
        guard let safeLevelRow = levelRow else { return [] }
        let exercises = getExercises(levelRow: safeLevelRow)
        return exercises
    }
    
    func getExercises(levelRow: [String]) -> [TimedMultiplying] {
        
        var exercises: [TimedMultiplying] = []
        for (index, column) in levelRow.enumerated() {
            if index != 0 {
                guard let exercise = getExercise(from: column) else { continue }
                exercises.append(exercise)
            }
        }
        
        return exercises
    }
    
    func getExercise(from column: String) -> TimedMultiplying? {
        let column_whitespaceless = column.trimmingCharacters(in: .whitespaces).lowercased()
        let exercise: TimedMultiplying? = nil
        let unknownPosition = getUnknownPosition(from: column_whitespaceless)
        let exOperator = getOperator(from: column_whitespaceless)
        
        switch unknownPosition {
        case .left:
            let exploded = column_whitespaceless.split(separator: exOperator.getSymbol().first ?? "0")
            if exploded.indices.contains(1) {
                let rightExploded = exploded[1].trimmingCharacters(in: .whitespaces).split(separator: "=")
                if rightExploded.indices.contains(0) && rightExploded.indices.contains(1) {
                    let sNumber = Float(rightExploded[0].trimmingCharacters(in: .whitespaces)) ?? 0
                    let rNumber = Float(rightExploded[1].trimmingCharacters(in: .whitespaces)) ?? 0
                    let fNumber: Float
                    switch exOperator {
                    case .div:
                        fNumber = rNumber * sNumber
                    case .tim:
                        fNumber = rNumber / sNumber
                    case .plus:
                        fNumber = rNumber - sNumber
                    case .minus:
                        fNumber = rNumber + sNumber
                    }
                    
                    return TimedMultiplying(left: fNumber, op: exOperator, right: sNumber, result: rNumber, unknown: unknownPosition)
                }
            }
        case .right:
            let exploded = column_whitespaceless.split(separator: exOperator.getSymbol().first ?? "0")
            if exploded.indices.contains(0) && exploded.indices.contains(1) {
                let rightExploded = exploded[1].trimmingCharacters(in: .whitespaces).split(separator: "=")
                if rightExploded.indices.contains(1) {
                    let fNumber = Float(exploded[0].trimmingCharacters(in: .whitespaces)) ?? 0
                    let sNumber: Float
                    let rNumber = Float(rightExploded[1].trimmingCharacters(in: .whitespaces)) ?? 0
                    
                    switch exOperator {
                    case .div:
                        sNumber = fNumber * rNumber
                    case .tim:
                        sNumber = rNumber / fNumber
                    case .plus:
                        sNumber = rNumber - fNumber
                    case .minus:
                        sNumber = rNumber + fNumber
                    }
                    
                    return TimedMultiplying(left: fNumber, op: exOperator, right: sNumber, result: rNumber, unknown: unknownPosition)
                }
            }
        case .result:
            let exploded = column_whitespaceless.split(separator: exOperator.getSymbol().first ?? "0")
            if exploded.indices.contains(0) && exploded.indices.contains(1) {
                let fNumber = Float(exploded[0]) ?? 0
                let sNumber = Float(exploded[1]) ?? 0
                let rNumber: Float
                
                switch exOperator {
                case .div:
                    rNumber = fNumber / sNumber
                case .tim:
                    rNumber = fNumber * sNumber
                case .plus:
                    rNumber = fNumber + sNumber
                case .minus:
                    rNumber = fNumber - sNumber
                }
                return TimedMultiplying(left: fNumber, op: exOperator, right: sNumber, result: rNumber, unknown: unknownPosition)
            }
        }
        
        return exercise
    }
    
    func getUnknownPosition(from column: String) -> UnknownPosition {
        if column.contains("?") {
            // left or right unknowns
            if column.first == "?" {
                return .left
            } else {
                return .right
            }
        } else {
            return .result
        }
    }
    
    func getOperator(from column: String) -> Operator {
        
        if column.contains("x") { return .tim }
        if column.contains("/") { return .div }
        if column.contains("+") { return .plus }
        if column.contains("-") { return .minus }
        
        return .div
    }
}
