//
//  BookMarkViewModel.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

protocol BookmarkVMOutput: class {
    func reloadData()
}

class BookmarkViewModel: ViewModel {

    weak var output: BookmarkVMOutput?
    var bookmarkData: [[String: Any]]?
    
    // MARK: Initializer.
    override init(withCoordinator: Coordinator?) {
        super.init(withCoordinator: withCoordinator)
    }

}

extension BookmarkViewModel {

    func controllerDidLoad() {
        retrieveValue(key: .bookmark)
    }

    func retrieveValue(key: UserPreferenceKey)  {
        if let data: [[String: Any]] = UserPreference.value(forKey: key) {
            bookmarkData = data
            output?.reloadData()
        }
    }

    func removeData(text: String) {
        let filterData = bookmarkData?.filter({ (bookmark) -> Bool in
            let publishedAt = bookmark["publishedAt"] as? String ?? ""
            return !publishedAt.contains(text)
        })
        
        DispatchQueue.main.async { [weak self] in
            self?.bookmarkData = filterData
            UserPreference.set(value: self?.bookmarkData, forKey: .bookmark)
        }
        output?.reloadData()
    }
}

extension BookmarkViewModel {

    func moveToSearchScreen() {
        coordinator?.raise(event: NewsEvent.searchScreen(data: []))
    }

}

extension BookmarkViewModel {
    
    func numberOfRows() -> Int {
        return bookmarkData?.count ?? 0
    }
    
    func dataForRows(indexPath: IndexPath) -> [String: Any]? {
        return bookmarkData?[indexPath.row]
    }
    
}
