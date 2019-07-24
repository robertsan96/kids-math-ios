//
//  InitialVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/23/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

enum InitialPinSetStep {
    case setPin, confirmPin
}

class InitialVM {
    
    var pin: [InitialPinSetStep: String] = [:]
    
    var pinStep: BehaviorSubject<InitialPinSetStep> = BehaviorSubject(value: .setPin)
}
