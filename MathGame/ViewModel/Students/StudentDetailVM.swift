//
//  StudentDetailVM.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum StudentDetailVMType {
    case edit, create
}

class StudentDetailVM {
    
    var student: Student?
    var type: BehaviorSubject<StudentDetailVMType> = BehaviorSubject(value: .create)
    var mode: BehaviorRelay<SettingsVCMode> = BehaviorRelay(value: .firstLaunch)
    
    init(with type: StudentDetailVMType, and student: Student?) {
        self.type.onNext(type)
        self.student = student
    }
    
    func createStudent(with fields: StudentDetailVCFields) {
        let cdh = CoreDataHelper()
        let student = Student(context: cdh.context)
        student.firstName = fields.firstName
        student.lastName = fields.lastName
        student.pin = fields.pin ?? 0000
        let _ = cdh.createOrUpdateStudent(student: student)
    }
}
