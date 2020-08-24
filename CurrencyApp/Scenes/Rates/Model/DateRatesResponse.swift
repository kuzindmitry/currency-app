//
//  DateRatesResponse.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

struct DateRatesResponse: Decodable {
    let rates: RatesResponse
    let date: String
    let base: String
    
    func value(for currency: Currency) -> Double {
        switch currency {
        case .USD:
            return rates.USD
        case .EUR:
            return rates.EUR ?? 1
        case .RUB:
            return rates.RUB
        }
    }
    
    func rate(from fromCurrency: Currency, to toCurrency: Currency) -> Double {
        if fromCurrency.rawValue == base {
            return value(for: toCurrency)
        } else if toCurrency.rawValue == base {
            return 1/value(for: fromCurrency)
        } else {
            if let baseCurrency = Currency(rawValue: base) {
                return value(for: toCurrency)/(value(for: fromCurrency)/value(for: baseCurrency))
            }
        }
        return 0
    }
}
