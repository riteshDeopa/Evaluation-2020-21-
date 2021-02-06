//
//  NewsCoordinator.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class NewsCoordinator: Coordinator {
    
    private weak var root: NewsViewController?

    /* Getter method for root */
    public func initialViewController() -> NewsViewController? {
        return root
    }

    override init(parent: Coordinator?) {
        super.init(parent: parent)
    }

    public func createFlow() -> UIViewController {
        root = UIStoryboard.mainStoryboard().instantiateViewController(forClass: NewsViewController.self)
        let viewModel = NewsViewModel(withCoordinator: self)
        root?.viewModel = viewModel
        viewModel.output = root
        return root ?? UIViewController()
    }
    
}
