//
//  DateRatesParameters.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

struct DateRatesParameters: APIParametersProtocol {
    
    let base: Currency
    let date: Date = Date()
    
    func convertToDictionary() -> [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return ["base": base.rawValue]
    }
}
