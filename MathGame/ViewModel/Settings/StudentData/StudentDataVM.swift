//
//  StudentDataVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/29/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StudentDataVM {
    
    var student: Student
    var games: BehaviorSubject<[GameSession]> = BehaviorSubject(value: [])
    
    var date: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var minDate: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var maxDate: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    init(with student: Student) {
        self.student = student
        let allGames = (student.gameSessions?.allObjects as! [GameSession]).sorted { (sessionOne, sessionTwo) -> Bool in
            guard let dateOne = sessionOne.date, let dateTwo = sessionTwo.date else { return false }
            return dateOne > dateTwo
        }
        self.games = BehaviorSubject(value: allGames)
    }
    
    func setGamesFor(date: Date) {
        let toDate = (student.gameSessions?.allObjects as! [GameSession]).filter { (game) -> Bool in
            let calendar = Calendar.current
            guard let gameDate = game.date else { return true }
            let gameComponent = calendar.dateComponents(in: .current, from: gameDate)
            let dateComponent = calendar.dateComponents(in: .current, from: date)
            
            if gameComponent.day == dateComponent.day &&
                gameComponent.month == dateComponent.month &&
                gameComponent.year == dateComponent.year {
                return true
            }
            return false
        }
        let allGames = toDate.sorted { (sessionOne, sessionTwo) -> Bool in
            guard let dateOne = sessionOne.date, let dateTwo = sessionTwo.date else { return false }
            return dateOne > dateTwo
        }
        self.games.onNext(allGames)
    }
}
