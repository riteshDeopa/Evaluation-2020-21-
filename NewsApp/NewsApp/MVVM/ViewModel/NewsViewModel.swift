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
    func reloadData()
    func showError(title: String?)
}

class NewsViewModel: ViewModel {
    
    weak var output: NewsViewModelOutput?
    var topNewsTitle: String?
    var topNewsDescription: String?
    var topNewsImg: String?
    var topNewsSourceName: String?
    var topNewslink: String?

    // MARK: Initializer.
    override init(withCoordinator: Coordinator?) {
        super.init(withCoordinator: withCoordinator)
    }

}


extension NewsViewModel {
    
    func controllerDidLoad() {
        createMockData()
        fetchTopNews(isMocking: true)
        fetchPopularNews(isMocking: true)
    }
    
    
    func fetchTopNews(isMocking: Bool) {
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
                self?.output?.reloadData()
            }
        }
    }


    func fetchPopularNews(isMocking: Bool) {
        output?.showActivityIndicator()
        NewsDataManager.fetchPopularNews(isMocking: isMocking) { [weak self] (data, error) in
            self?.output?.hideActivityIndicator()
            if let error = error {
                let handled = self?.handleCommonAPIError(error: error)
                if let handled = handled, !handled {
                    self?.output?.showError(title: "Something Went Wrong")
                }
            } else {
                self?.output?.reloadData()
            }
        }
    }

}


extension NewsViewModel {
    func handleCommonAPIError(error: APIError) -> Bool {
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
    func createMockData() {
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
