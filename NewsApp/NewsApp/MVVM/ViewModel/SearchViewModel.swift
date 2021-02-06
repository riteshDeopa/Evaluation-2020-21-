//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

protocol SearchViewModelOutput: class {
    func reloadData()
}


class SearchViewModel: ViewModel {

    weak var output: SearchViewModelOutput?
    var data: [Articles]?
    var recentSearch = [String]()
    var filterRecentSearch = [String]()

    // MARK: Initializer.
    init(withCoordinator: Coordinator?, data: [Articles]) {
        super.init(withCoordinator: withCoordinator)
        self.data = data
    }
    
}

extension SearchViewModel {

    func numberOfRows() -> Int {
        return filterRecentSearch.count
    }

    func dataForRows(indexPath: IndexPath) -> String? {
        return filterRecentSearch[indexPath.row]
    }

}

extension SearchViewModel {

    func retrieveValue(key: UserPreferenceKey) {
        if let data: [String] = UserPreference.value(forKey: key) {
            recentSearch = data
            filterRecentSearch = data
        }
        output?.reloadData()
    }

    func saveValue(key: UserPreferenceKey, text: String) {
        if !checkStringAlreadySearched(text: text) {
            recentSearch.append(text)
            DispatchQueue.main.async { [weak self] in
                UserPreference.set(value: self?.recentSearch, forKey: key)
                self?.retrieveValue(key: .search)
            }
        }
    }

    func checkStringAlreadySearched(text: String) -> Bool {
        filterRecentSearch = recentSearch.filter({ (recentSearch) -> Bool in
            return recentSearch.contains(text.lowercased())
        })
        if filterRecentSearch.count == 0 {
            return false
        } else {
            return true
        }
    }

}
