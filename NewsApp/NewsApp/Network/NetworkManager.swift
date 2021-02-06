//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit


class NetworkManager: NSObject {

    var session: URLSession!
    static let shared = NetworkManager()
    //For unit testing
    static let mockInstance = NetworkManager(mockUrlSession: MockURLSession())

    private init(mockUrlSession: URLSession? = nil) {
        super.init()
        guard let mockSession = mockUrlSession else {
           session = URLSession(configuration: defaultConfiguration)
            return
        }
        session = mockSession
    }

    fileprivate var defaultConfiguration: URLSessionConfiguration! {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        return config
    }

    func request(urlString: String,
                 method: String,
                 parameters: [String: Any]?,
                 headers: [String: String]?) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method

        //Request body
        if let jsonDict = parameters,
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
            request.httpBody = jsonData
        }

        //Request headers
        if let headerFields = headers {
            for (key, value) in headerFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}

// MARK: - Reachability
extension NetworkManager {
    func isNetworkReachable() -> Bool {
        do {
            return try Reachability().connection != .unavailable
        } catch {
            return false
        }
    }
}
