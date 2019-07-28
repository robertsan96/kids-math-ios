//
//  GamesVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

class GamesVM {
    
    var student: BehaviorSubject<Student>
    var games: BehaviorSubject<[Game]> = BehaviorSubject(value: [
        .numbersBond10,
        .numbersBond20,
        .halves,
        .doubles,
        .adding,
        .takeAways,
        .timesTable,
        .dividing,
        .timedMultiplying
    ])
    
    init(with student: Student) {
        self.student = BehaviorSubject(value: student)
    }
    
    func getStudent() -> Student? {
        do {
            let student = try self.student.value()
            return student
        } catch {
            return nil
        }
    }
}
