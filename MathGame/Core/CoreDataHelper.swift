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
}

class CoreDataHelper {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var isFirstLaunch: Bool {
        
        if let valueRaw = getStockValue(for: CoreDataStockKeys.firstLaunch.rawValue) {
            return (valueRaw == "false") ? true : false
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
    
    
}
