//
//  SettingsVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

enum SettingsVCMode {
    case firstLaunch, normal
}

enum SettingsOptions {
    case addStudent, deleteStudent, resetStudent, changePin
    
    func getTitle() -> String {
        
        switch self {
        case .addStudent: return "Add Student"
        case .deleteStudent: return "Delete Student"
        case .resetStudent: return "Reset Student"
        case .changePin: return "Change PIN"
        }
    }
    
    func getContainerColor() -> UIColor {
        switch self {
        default: return Constants.Colors.createStudent
        }
    }
}

class SettingsVM {
    
    let mode: SettingsVCMode
    let options: BehaviorSubject<[SettingsOptions]> = BehaviorSubject(value: [.addStudent, .deleteStudent, .resetStudent, .changePin])
    
    init(mode: SettingsVCMode) {
        self.mode = mode
    }
}
