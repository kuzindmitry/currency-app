//
//  EndPointProtocol.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

protocol EndPointProtocol {
    var url: URL? { get }
}

enum EndPoint: String, EndPointProtocol {

    case latest = "/latest"
    
    var host: String {
        return "https://api.exchangeratesapi.io"
    }
    
    var url: URL? {
        return URL(string: host + rawValue)
    }
    
}
