//
//  APIClient.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-06-23.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

// TODO: Proper SSL Validation and Pinning
class OverTrustingServerTrustPolicyManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    
    init() {
        super.init(policies: [:])
    }
}

extension HTTPURLResponse {
    func caseInsensitiveHeader(_ field : String) -> String? {
        if let value = allHeaderFields[field] as? String { return value }
        if let value = allHeaderFields[field.lowercased()] as? String { return value }
        return nil
    }
}

class APIRetrier : RequestRetrier {
  
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(false, 0)
    }
}
/***
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            if let endpointString = response.caseInsensitiveHeader(" "), let endpoint = URL(string: endpointString) {
                // Login is needed!
                Async.main {
                    BBOAuth.loginAndRetry(endpoint: endpoint, completion: completion)
                }
                return
            }
            else if let endpointString = response.caseInsensitiveHeader("X-Authorization-Endpoint"), let endpoint = URL(string: endpointString) {
                // Login is needed!
                Async.main {
                    BBOAuth.loginAndRetry(endpoint: endpoint, completion: completion)
                }
                return
            }
            else {
                EVLog("Request returned 401 but auth header is incorrect response = " + response.debugDescription)
                return
            }
        }
        else {
            if let response = request.task?.response as? HTTPURLResponse {
                EVLog("Error code = " + response.debugDescription)
                
            }
            completion(false, 0)
        }
    }
 
***/

var APISession : Alamofire.SessionManager = {
    // Create custom manager
    let configuration = URLSessionConfiguration.default
    let manager = Alamofire.SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: OverTrustingServerTrustPolicyManager()
    )
    manager.retrier = APIRetrier()
    return manager
}()

class APIClient {
    
    typealias GetObjectsResult<T: BaseMappable> = (_ responseObject: [T], _ error: Error?) -> ()
    typealias GetObjectResult<T: BaseMappable> = (_ responseObject: T?, _ error: Error?) -> ()
    
    // Fetch data from the server
    class func getObjectsFromServer<T: BaseMappable>(_ url: URLConvertible, parameters: Parameters? = nil, ofType: T.Type, completion: @escaping GetObjectsResult<T>) {
        print("in getObjectsFromServer()")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let token = UserSession.shared.getToken() else {
            print("Error: getMyProfile(): token is nil")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        APISession.request(url,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.queryString,
                          headers: headers).validate().responseArray() {
                            (res: DataResponse<[T]>) in
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            completion(res.result.value ?? [], res.result.error)
        }
    }
 
    // Fetch data from the server
    // This is a REST hack. Using a POST with a json body to pass a long query string
    class func getObjectsEncFromServer<T: BaseMappable>(_ url: URLConvertible, parameters: Parameters? = nil, ofType: T.Type, completion: @escaping GetObjectsResult<T>) {
        print("in getObjectsEncFromServer()")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let token = UserSession.shared.getToken() else {
            print("Error: getMyProfile(): token is nil")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        APISession.request(url,
                           method: .post,
                           parameters: parameters,
                           encoding: URLEncoding.default,
                           headers: headers).validate().responseArray() {
                            (res: DataResponse<[T]>) in
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            completion(res.result.value ?? [], res.result.error)
        }
    }

    
    // Post an object to the server
    class func postObjectToServer<T: BaseMappable>(_ url: URLConvertible, object: T) {
        guard let token = UserSession.shared.getToken() else {
            print("Error: postObjectToServer(): token is nil")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        
        let json = object.toJSON()
        APISession.request(url, method:.post, parameters:json, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

    // Post an object to the server, with completion handler
    class func postObjectToServer<T: BaseMappable>(_ url: URLConvertible, object: T, completion: @escaping GetObjectResult<T>) {
        guard let token = UserSession.shared.getToken() else {
            print("Error: postObjectToServer(): token is nil")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        
        let json = object.toJSON()
        APISession.request(url, method:.post, parameters:json, encoding: JSONEncoding.default, headers: headers).responseObject() {
            (response: DataResponse<T>) in
                completion(response.result.value, response.result.error)
        }
    }

    // Update an object on the server
    class func updateObjectToServer<T: BaseMappable>(_ url: URLConvertible, object: T) {
        guard let token = UserSession.shared.getToken() else {
            print("Error: updateObjectToServer(): token is nil")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        
        let json = object.toJSON()
        APISession.request(url, method:.put, parameters:json, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Delete an object from the server
    class func deleteObjectFromServer(_ url: URLConvertible) {
        guard let token = UserSession.shared.getToken() else {
            print("Error: deleteObjectFromServer(): token is nil")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        
        APISession.request(url, method:.delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }


    // Upload an image to the server
    class func uploadImage(_ imageName: String, image: UIImage) {
        let imgData = image.jpegData(compressionQuality: 0.2)
        
        guard let token = UserSession.shared.getToken() else {
            print("Error: uploadImage(): token is nil")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        
        APISession.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "image", fileName: imageName, mimeType: "image/jpg")},
                         to: Constants.ImagesURL, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }}
    }

}
