//
//  Storyboard.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

enum ViewControllerIdentifiers: String {
    
    case mainVC = "MainVC"
    case initialVC = "InitialVC"
}

class Storyboard {
    
    static var shared: Storyboard = Storyboard()
    
    private init() { }
    
    func getViewController<T: UIViewController>(by viewControllerIdentifiers: ViewControllerIdentifiers) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifiers.rawValue)
        return vc as! T
    }
}
