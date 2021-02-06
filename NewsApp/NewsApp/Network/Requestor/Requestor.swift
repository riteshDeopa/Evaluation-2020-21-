//
//  Requestor.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import Foundation

class Requestor {

    let apiResource: APIResource!
    let decoder = JSONDecoder()
    
    private var netWorkManager: NetworkManager {
        return {
            apiResource.isMocking ? NetworkManager.mockInstance: NetworkManager.shared
        }()
    }
    
    init(resource: APIResource?) {
        self.apiResource = resource
    }
    
    final var httpMethod: String {
        return self.apiResource.method.rawValue
    }
    
    /**
     Creates a `DataRequest` using Alamofire's request method.
     
     - Returns: `DataRequest` created by Alamofire.
     */
    internal func sendRequest() -> URLRequest? {
        
        let request = netWorkManager.request(urlString: apiResource.urlString,
                                             method: self.httpMethod,
                                             parameters: apiResource.parameter,
                                             headers: nil)
        return request
    }
    
    /**
     It will create network request to get the data from specified URL
     ## Note ##
     This is a generic requestor method. Here we need to specify data type we requesting for.
     And in completion block this will return same type of data.
     
     - Retruns: unique data request ID of type `String`
     */
    func sendRequest(completion: ((_ data: Data?, _ response: URLResponse?, _ error: APIError?) -> Void)?) {
        guard netWorkManager.isNetworkReachable() else {
            completion?(nil, nil, APIError.noInternetConnection)
            return
        }
        guard let request = self.sendRequest() else { return }
        let dataTask = netWorkManager.session.dataTask(with: request,
                                                       completionHandler: {
                                                        (data, urlResponse, error)  in
                                                        DispatchQueue.main.async {
                                                            self.printResponse(data, response: urlResponse, error: error)
                                                            let validation = self.validate(data: data, error: error)
                                                            if validation.success, let data = data {
                                                                completion?(data, urlResponse, nil)
                                                            } else {
                                                                completion?(nil, urlResponse, validation.error ?? APIError.somethingWentWrong)
                                                            }
                                                        }
                                                       })
        dataTask.resume()
    }

    
    /**
     Validates the data and error in basic level.
     1. Data should not be nil
     2. There should not be any error.
     
     - parameter data: resposne data
     - parameter error: response error
     - Returns: A *tuple* with success flag and optional APIError
    */
    func validate(data: Any?, error: Error?) -> (success: Bool, error: APIError?) {

        ///Here just basic validation checking data is nil or not and error is present.
        var validationError: APIError?
        if data == nil {
            validationError = APIError.invalidResponse
        }
        if error != nil {
            let code = (error as NSError?)?.code
            let msg = (error as NSError?)?.localizedDescription
            if ((code ?? 0) == -999) && ((msg ?? "").lowercased() == "cancelled") {
                validationError = APIError.requestCancelled
            } else {
                validationError = APIError.generalError(code: code, message: msg)
            }
        }
        let status = (validationError == nil) ? true : false
        return (status, validationError)
    }


    
    func printResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        
        print("===================================================================")
        print("Response:")
        print("DebugDescription")
        if let response = response {
            print(response)
        }
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json )
            } catch let error {
                print(error)
            }
        }
        if let error = error {
            print(error)
        }
        print("===================================================================\n\n")
    }
}
