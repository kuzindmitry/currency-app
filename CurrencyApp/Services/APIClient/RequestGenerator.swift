//
//  RequestGenerator.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

struct RequestGenerator<T: Decodable>: APIRequestProtocol  {
    
    typealias ResponseType = T
    
    var type: APIRequestType
    var encodingType: EncodingType
    var endPoint: EndPointProtocol
    var parameters: APIParametersProtocol?
    
    init(type: APIRequestType, encodingType: EncodingType, endPoint: EndPointProtocol, parameters: APIParametersProtocol?) {
        self.type = type
        self.encodingType = encodingType
        self.endPoint = endPoint
        self.parameters = parameters
    }
}
