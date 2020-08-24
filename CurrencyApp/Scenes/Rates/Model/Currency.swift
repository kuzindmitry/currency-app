//
//  Currency.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

typealias CurrencyVariant = (from: Currency, to: Currency, title: String)

enum Currency: String, CaseIterable {
    case USD
    case EUR
    case RUB
    
    var title: String {
        switch self {
        case .USD: return "usd_title".localized
        case .EUR: return "eur_title".localized
        case .RUB: return "rub_title".localized
        }
    }
    
    static var variants: [CurrencyVariant] {
        var results: [CurrencyVariant] = []
        for currency in Currency.allCases {
            var cases = Currency.allCases
            if let index = cases.firstIndex(of: currency) {
                cases.remove(at: index)
            }
            cases.forEach {
                results.append((from: currency, to: $0, title: currency.rawValue + " → " + $0.rawValue))
            }
        }
        return results
    }
}
