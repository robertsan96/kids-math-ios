//
//  Date.swift
//  MathGame
//
//  Created by Robert Sandru on 7/29/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

extension Date {

    var humanized: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, hh:mm"
        return formatter.string(from: self as Date)
    }
}
