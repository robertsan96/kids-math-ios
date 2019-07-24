//
//  StudentsVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

enum StudentsMode {
    case normal, delete, reset
}

class StudentsVM {
    
    var students: BehaviorSubject<[Student]> = BehaviorSubject(value: [])
    var mode: StudentsMode = .normal
    
    init(with mode: StudentsMode = .normal) {
        students.onNext(getStudents())
        self.mode = mode
    }
    
    func getStudents() -> [Student] {
        let coreDataHelper = CoreDataHelper()
        let students = coreDataHelper.getStudents()
        return students
    }
    
    func getStudentAt(row: Int) -> Student? {
        do {
            let student = try students.value()[row]
            return student
        } catch {
            return nil
        }
    }
    
    func refreshStudents() {
        students.onNext(getStudents())
    }
}
