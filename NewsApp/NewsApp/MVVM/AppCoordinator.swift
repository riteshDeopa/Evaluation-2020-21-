//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit


public final class AppCoordinator: Coordinator {

    private unowned let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
        super.init(parent: nil)
    }

    public func startFlow() {
        presentMainFlow()
    }
}

extension AppCoordinator {

     func presentMainFlow() {
        let newsCoordinator = NewsCoordinator(parent: self)
        let newsRootVC = newsCoordinator.createFlow()
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [newsRootVC]
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
