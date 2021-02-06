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
        newsEventHandler()
    }
    
    public func createFlow() -> UIViewController {
        root = UIStoryboard.mainStoryboard().instantiateViewController(forClass: NewsViewController.self)
        let viewModel = NewsViewModel(withCoordinator: self)
        root?.viewModel = viewModel
        viewModel.output = root
        return root ?? UIViewController()
    }
    
}


extension NewsCoordinator {
    private func newsEventHandler() {
        addHandler { [weak self] (event: NewsEvent) in
            switch event {
            case .searchScreen(let data):
                self?.navigateToSearchScreen(data: data)
            case .bookmark:
                self?.navigateToBookmarkScreen()
            }
        }
    }
}

extension NewsCoordinator {

    private func navigateToSearchScreen(data: [Articles]) {
        guard let vControler = UIStoryboard.mainStoryboard().instantiateViewController(
                forClass: SearchViewController.self) else { return }
        let viewModel = SearchViewModel(withCoordinator: self, data: data)
        vControler.viewModel = viewModel
        viewModel.output = vControler
        root?.navigationController?.pushViewController(vControler, animated: true)
    }


    private func navigateToBookmarkScreen() {
        guard let vControler = UIStoryboard.mainStoryboard().instantiateViewController(
                forClass: BookmarkViewController.self) else { return }
        let viewModel = BookmarkViewModel(withCoordinator: self)
        vControler.viewModel = viewModel
        viewModel.output = vControler
        root?.navigationController?.pushViewController(vControler, animated: true)
    }
}
