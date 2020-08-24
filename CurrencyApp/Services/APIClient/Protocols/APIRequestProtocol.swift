//
//  APIRequestProtocol.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

enum EncodingType {
    case url
    case json
    case query
}

enum APIRequestType {
    case post
    case get
    case put
    case delete
    case patch
}

protocol APIRequestProtocol {
    associatedtype ResponseType: Decodable
    var type: APIRequestType { get }
    var encodingType: EncodingType { get }
    var endPoint: EndPointProtocol { get }
    var parameters: APIParametersProtocol? { get set }
}
