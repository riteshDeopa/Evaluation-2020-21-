//
//  NewsDataManager.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class NewsDataManager: NSObject {

    class func fetchTopNews(parameter: [String: Any]? = nil,
                        isMocking: Bool = false,
                        completionHandler: ((_ data: NewsModel?, _ error: APIError?) -> Void)?) {
        let url = API.topHeadlines.withCountryCode(countryCode: CountryISOCode.india)
        let resource = APIResource(URLString: url, method: .get,
                                   parameters: parameter, contentType: .json,
                                   isMocking: isMocking)
        Requestor(resource: resource).sendRequest { (data, urlResponse, error) in
            self.parseData(data: data, error: error) { (data, error) in
                completionHandler?(data, error)
            }
        }
    }


    class func fetchPopularNews(parameter: [String: Any]? = nil,
                        isMocking: Bool = false,
                        completionHandler: ((_ data: NewsModel?, _ error: APIError?) -> Void)?) {
        let url = API.popularNews.withBaseURL
        let resource = APIResource(URLString: url, method: .get,
                                   parameters: parameter, contentType: .json,
                                   isMocking: isMocking)
        Requestor(resource: resource).sendRequest { (data, urlResponse, error) in
            self.parseData(data: data, error: error) { (data, error) in
                completionHandler?(data, error)
            }
        }
    }


    class func parseData(data: Data?, error: APIError?, completionHandler: ((_ data: NewsModel?, _ error: APIError?) -> Void)?) {
        guard let data = data else {
            completionHandler?(nil, error)
            return
        }
        do {
            let decodedData = try JSONDecoder().decode(NewsModel.self, from: data)
            completionHandler?(decodedData, nil)
        } catch {
            completionHandler?(nil, APIError.parsingError)
        }
    }

}
