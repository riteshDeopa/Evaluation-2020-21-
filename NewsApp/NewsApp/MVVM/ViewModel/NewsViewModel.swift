//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

 protocol NewsViewModelOutput: class {
    func showActivityIndicator()
    func hideActivityIndicator()
    func reloadDataForTopNews()
    func reloadDataForPopularNews()
    func showError(title: String?)
}

class NewsViewModel: ViewModel {
    
    weak var output: NewsViewModelOutput?
    var topNewsTitle: String?
    var topNewsDescription: String?
    var topNewsImg: String?
    var topNewsSourceName: String?
    var topNewslink: String?
    var topPublishedAt: String?
    var popularNews: [Articles]?
    var bookmarkArray = [[String: Any]]()

    // MARK: Initializer.
    override init(withCoordinator: Coordinator?) {
        super.init(withCoordinator: withCoordinator)
    }

}

extension NewsViewModel {

    func createBookmark(data: Articles? = nil) {
        var arrayDict = [[String: Any]]()
        var dict = [String: Any]()
        dict["title"] = data?.title == nil ? topNewsTitle : data?.title
        dict["description"] = data?.description == nil ? topNewsDescription : data?.description
        dict["urlToImage"] = data?.urlToImage == nil ?  topNewsImg : data?.urlToImage
        dict["sourceName"] = data?.source?.name == nil ? topNewsSourceName : data?.source?.name
        dict["url"] = data?.url == nil ? topNewslink : data?.url
        dict["publishedAt"] = data?.publishedAt == nil ? topPublishedAt : data?.publishedAt
        arrayDict.append(dict)
        saveValue(key: .bookmark, data: arrayDict, searchText: (data?.publishedAt == nil ? topPublishedAt : data?.publishedAt) ?? "")
    }

    private func saveValue(key: UserPreferenceKey, data: [[String: Any]], searchText: String) {
        if !checkStringAlreadyExist(text: searchText) {
            DispatchQueue.main.async { [weak self] in
                self?.bookmarkArray.append(contentsOf: data)
                UserPreference.set(value: self?.bookmarkArray, forKey: key)
            }
        }
    }


    private func checkStringAlreadyExist(text: String) -> Bool {
        let filterData = bookmarkArray.filter({ (bookmark) -> Bool in
            let publishedAt = bookmark["publishedAt"] as? String ?? ""
            return publishedAt.contains(text)
        })
        if filterData.count == 0 {
            return false
        } else {
            return true
        }
    }


    private func retrieveValue(key: UserPreferenceKey) {
        if let data: [[String: Any]] = UserPreference.value(forKey: key) {
            bookmarkArray = data
        }
    }

}

extension NewsViewModel {

    func numberOfRows() -> Int {
        return popularNews?.count ?? 0
    }

    func dataForRows(indexPath: IndexPath) -> Articles? {
        return popularNews?[indexPath.row]
    }

    func moveToSearchScreen() {
        coordinator?.raise(event: NewsEvent.searchScreen(data: popularNews ?? []))
    }
    
    func moveToBookmarkScreen() {
        coordinator?.raise(event: NewsEvent.bookmark)
    }
}

extension NewsViewModel {
    
    func controllerDidLoad() {
        createMockData()
        fetchTopNews(isMocking: false)
        fetchPopularNews(isMocking: false)
        retrieveValue(key: .bookmark)
    }
    
    
    private func fetchTopNews(isMocking: Bool) {
        output?.showActivityIndicator()
        NewsDataManager.fetchTopNews(isMocking: isMocking) { [weak self] (data, error) in
            self?.output?.hideActivityIndicator()
            if let error = error {
                let handled = self?.handleCommonAPIError(error: error)
                if let handled = handled, !handled {
                    self?.output?.showError(title: "Something Went Wrong")
                }
            } else {
                self?.topNewsImg = data?.articles?.first?.urlToImage
                self?.topNewsTitle = data?.articles?.first?.title
                self?.topNewsDescription = data?.articles?.first?.description
                self?.topNewsSourceName = data?.articles?.first?.source?.name
                self?.topNewslink = data?.articles?.first?.url
                self?.topPublishedAt = data?.articles?.first?.publishedAt
                self?.output?.reloadDataForTopNews()
            }
        }
    }


    private func fetchPopularNews(isMocking: Bool) {
        output?.showActivityIndicator()
        NewsDataManager.fetchPopularNews(isMocking: isMocking) { [weak self] (data, error) in
            self?.output?.hideActivityIndicator()
            if let error = error {
                let handled = self?.handleCommonAPIError(error: error)
                if let handled = handled, !handled {
                    self?.output?.showError(title: "Something Went Wrong")
                }
            } else {
                self?.popularNews = data?.articles
                self?.output?.reloadDataForPopularNews()
            }
        }
    }

}


extension NewsViewModel {
    private func handleCommonAPIError(error: APIError) -> Bool {
        //here we will process different errors
        var handled = true
        switch error {
        case .noInternetConnection:
            self.output?.showError(title: "No Internet Connection! Please check the connection and retry again")
        case .invalidRequest:
            self.output?.showError(title: "Invalid Request")
        case .generalError( _, let message):
            self.output?.showError(title: message)
        default:
            handled = false
        }
        return handled
    }
}


extension NewsViewModel {
    private func createMockData() {
        let fileName = "News"
        if let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") {
            if FileManager.default.fileExists(atPath: filePath) {
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath),
                                            options: Data.ReadingOptions.mappedIfSafe)
                    MockURLSession.data = jsonData
                    guard let url = URL(string: API.popularNews.withBaseURL) else { return }
                    MockURLSession.response = HTTPURLResponse(url: url, statusCode: 200,
                                                              httpVersion: nil, headerFields: nil)
                    MockURLSession.error = nil
                } catch {
                }
            }
        }
    }
}
