//
//  CoreDataHelper.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataEntities: String {
    case stock = "Stock"
    case gameLog = "GameLog"
    case student = "Student"
}

enum CoreDataStockKeys: String {
    case firstLaunch = "FIRST_LAUNCH"
    case masterPin = "MASTER_PIN"
}

typealias GameSessionLogFields = (
    answer: Float,
    correct: Bool,
    date: Date,
    question: String
)

class CoreDataHelper {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var isFirstLaunch: Bool {
        
        if let valueRaw = getStockValue(for: CoreDataStockKeys.firstLaunch.rawValue) {
            return (valueRaw == "false") ? false : true
        } else {
            return true
        }
    }
    
    func getStockValue(for searchKey: String) -> String? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.stock.rawValue)
        do {
            let dataRaw = try context.fetch(request)
            guard let data = dataRaw as? [Stock] else {
                return nil
            }
            
            for stockData in data {
                if stockData.key == searchKey {
                    return stockData.value
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func createOrUpdateStockValue(for key: CoreDataStockKeys, value: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.stock.rawValue)
        do {
            let dataRaw = try context.fetch(request)
            guard let data = dataRaw as? [Stock] else {
                return
            }
            
            var shouldCreate: Bool = true
            var updatingStock: Stock?
            for stockData in data {
                if stockData.key == key.rawValue {
                    shouldCreate = false
                    updatingStock = stockData
                }
            }
            if shouldCreate {
                let newStock = Stock(context: context)
                newStock.key = key.rawValue
                newStock.value = value
                try context.save()
            } else {
                updatingStock?.value = value
                try context.save()
            }
        } catch {}
    }
}

extension CoreDataHelper {
    
    func getStudents() -> [Student] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.student.rawValue)
        do {
            let dataRaw = try context.fetch(request)
            guard let data = dataRaw as? [Student] else {
                return []
            }
            return data
        } catch {
            return []
        }
    }
    
    func createOrUpdateStudent(student: Student) -> Student? {
        do {
            try context.save()
            return student
        } catch {
            return nil
        }
    }
    
    func deleteStudent(student: Student) {
        context.delete(student)
    }
    
    func createGameSession(for student: Student,
                           and game: Game,
                           and timedLevel: String? = nil) -> GameSession? {
        let gameSession = GameSession(context: context)
        gameSession.date = Date()
        gameSession.game = game.getName()
        gameSession.timed_level = timedLevel
        student.addToGameSessions(gameSession)
        student.lastActivity = Date()
        do {
            try context.save()
            return gameSession
        } catch {
            return nil
        }
    }
    
    func createGameLog(for gameSession: GameSession, and log: GameSessionLogFields) -> GameLog? {
        let gameLog = GameLog(context: context)
        gameLog.answer = log.answer
        gameLog.correct = log.correct
        gameLog.date = log.date
        gameLog.question = log.question
        gameSession.addToLogs(gameLog)
        do {
            try context.save()
            return gameLog
        } catch {
            return nil
        }
    }
    
    func deleteGameSessions(for student: Student) {
        for gameSession in student.gameSessions?.allObjects as? [GameSession] ?? [] {
            context.delete(gameSession)
            
        }
        do {
            try context.save()
        } catch { }
    }
}
