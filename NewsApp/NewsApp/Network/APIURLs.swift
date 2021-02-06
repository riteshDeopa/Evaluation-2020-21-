//
//  APIURLs.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import Foundation

/// Server base URL string.
public let kBaseURL = "http://newsapi.org/v2/"
private let apiKey = "929cfa06a5b441319b7c5bd76ec51666"

// MARK: - API's list
enum API: String {

    case topHeadlines = "top-headlines?"
    case popularNews = "everything?q=Apple&from=2021-02-06&sortBy=popularity&"

    var withBaseURL: String {
        return kBaseURL + self.rawValue + "apiKey=\(apiKey)"
    }

    func withCountryCode(countryCode: CountryISOCode) -> String {
        return kBaseURL + self.rawValue + "country=\(CountryISOCode.india.rawValue)&" + "apiKey=\(apiKey)"
    }

}

enum CountryISOCode: String {

    case india = "in"

}
