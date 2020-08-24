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

extension EndPointProtocol {
    
    var host: String {
        return "https://api.exchangeratesapi.io"
    }
    
}

struct DateEndPoint: EndPointProtocol {
    let date: Date
    
    var url: URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return URL(string: host + "/" + dateFormatter.string(from: date))
    }
    
}
