
//
//  APIResource.swift
//  ITD
//
//  Created by Guruprasanna on 09/07/20.
//  Copyright © 2020 Guruprasanna. All rights reserved.
//

import Foundation

public enum RequestMethod: String {
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case get     = "GET"
}

public enum RequestContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
    case multipart = ""
}

struct APIResource {

    ///Full URL string
    let urlString: String
    let method: RequestMethod
    let contentType: RequestContentType
    let parameter: [String: Any]?
    let customHeader: [String: String]?
    let isMocking: Bool
    ///By default for every API response json will be parsed from root level. If we need to parse response from any child items we can specify here.
    let responseKeyPath: String?
    ///If session gets expired, it will be handled in base level. If we require it in completion block, set this flag. Currently being used for touch/face ID login.
    var shouldReturnSessionExpiry: Bool = false
    /**
     API Resource constructor.
     - parameter url: Complete URL string.
     - parameter method: request method of type RequestMethod. By default method will be .get
     - parameter parameters: request parameters. For get method this be passes as URL parameters, for post & put this will be passed as body paramaters. Default is nil.
     - parameter headers: Any specific headers required for the API. **No need to pass common headers.**.
     - parameter contentType: content type of type RequestContentType. This value will be set for the header field **Content-Type**. Default value is .urlEncoded
     - parameter responseKey: Key path in the response json to be considered for parsing. By default response json will be parsed from root level.
     - parameter isMocking: Boolian to indicate whether to mock URLsession
    */
    init(URLString url: String, method: RequestMethod = .get,
         parameters: [String: Any]? = nil, headers: [String: String]? = nil,
         contentType: RequestContentType = .urlEncoded, responseKey: String? = nil, isMocking: Bool = false) {

        self.urlString = url
        self.method = method
        self.contentType = contentType
        self.parameter = parameters
        self.isMocking = isMocking
        self.customHeader = headers
        self.responseKeyPath = responseKey
    }
}

public enum APIError: Error {

    case noInternetConnection
    case invalidResponse
    case invalidRequest
    case parsingError
    case somethingWentWrong
    case requestCancelled
    case generalError(code: Int?, message: String?)

}
