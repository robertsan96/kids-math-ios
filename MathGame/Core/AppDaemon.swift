//
//  AppDaemon.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class AppDaemon {
    
    static var shared: AppDaemon = AppDaemon()
    
    private init() {}
    
    func start(with window: UIWindow?, root viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
