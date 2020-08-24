//
//  APIClientProtocol.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation
import Alamofire

protocol APIClientProtocol {
    func fetch<T: APIRequestProtocol>(request: T, completion: @escaping (Result<T.ResponseType, Error>) -> ())
    func uploadData<T: APIRequestProtocol>(request: T, fileName: String, data: Data, completion: @escaping (Result<T.ResponseType, Error>) -> ())
}

enum APIClientError: Error {
    case unknownError
}

extension APIClientProtocol {
    
    func fetch<T: APIRequestProtocol>(request: T, completion: @escaping (Result<T.ResponseType, Error>) -> ()) {
        
        guard let url = request.endPoint.url else { return }
        
        let p = request.parameters?.convertToDictionary()
        AF.request(url,method: getHTTPMethod(with: request),
                   parameters: p,
                   encoding: getEncoding(with: request),
                   headers: getHeader(forEndPoint: request.endPoint)).responseJSON { (callback) in
                    self.handle(request: request, andCallback: callback, completion: completion)
        }
    }
    
    
    func uploadData<T: APIRequestProtocol>(request: T, fileName: String, data: Data, completion: @escaping (Result<T.ResponseType, Error>) -> ()) {
        
        guard let url = request.endPoint.url else { return }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "ProfilePicture", fileName: fileName, mimeType: "image/png")
            
        }, to: url, method: .post, headers: headers)
            .responseJSON { (callback) in
                self.handle(request: request, andCallback:callback , completion: completion)
        }
    }
}

private extension APIClientProtocol {
    
    func getHeader(forEndPoint endPoint: EndPointProtocol) -> HTTPHeaders? {
        return [:]
    }
    
    func getEncoding<T: APIRequestProtocol>(with request: T) -> ParameterEncoding {
        
        switch request.encodingType {
        case .json: return  JSONEncoding.default
        case .url : return  URLEncoding.default
        case .query : return URLEncoding(destination: .queryString)
        }
        
    }
    
    func getHTTPMethod<T: APIRequestProtocol>(with request: T) -> HTTPMethod {
        switch request.type {
        case .post: return .post
        case .get: return .get
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        }
    }
    
    func handle<T: APIRequestProtocol>(request: T, andCallback callback: AFDataResponse<Any>, completion: (Result<T.ResponseType, Error>) -> ()) {
        
        if let data = callback.data, let statusCode = callback.response?.statusCode {
            print(String(data: data, encoding: .utf8) ?? "")
            let decoder = JSONDecoder()
            switch statusCode {
                
            case 200...300:
                do {
                    let result = try decoder.decode(T.ResponseType.self, from: data)
                    completion(.success(result))
                } catch let error {
                    print(error)
                    completion(.failure(error))
                }
            default:
                completion(.failure(APIClientError.unknownError))
            }
        } else {
            completion(.failure(callback.error ?? APIClientError.unknownError))
        }
    }
}
