//
//  StudentsVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift

class StudentsVM {
    
    var students: BehaviorSubject<[Student]> = BehaviorSubject(value: [])
    
    init() {
        students.onNext(getStudents())
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
}
