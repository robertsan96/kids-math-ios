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
}
