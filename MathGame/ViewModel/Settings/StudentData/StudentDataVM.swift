//
//  StudentDataVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/29/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

class StudentDataVM {
    
    var student: Student
    var games: BehaviorSubject<[GameSession]>
    
    init(with student: Student) {
        self.student = student
        let allGames = (student.gameSessions?.allObjects as! [GameSession]).sorted { (sessionOne, sessionTwo) -> Bool in
            guard let dateOne = sessionOne.date, let dateTwo = sessionTwo.date else { return false }
            return dateOne > dateTwo
        }
        self.games = BehaviorSubject(value: allGames)
    }
}
