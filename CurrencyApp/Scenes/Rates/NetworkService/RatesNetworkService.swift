//
//  CurrencyNetworkService.swift
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

struct LatestRatesResponse: Decodable {
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

struct RatesResponse: Decodable {
    let USD: Double
    let EUR: Double?
    let RUB: Double
}

struct LatestRatesParameters: APIParametersProtocol {
    
    let base: Currency
    let date: Date = Date()
    
    func convertToDictionary() -> [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return ["base": base.rawValue]
    }
}

class RatesNetworkService: APIClientProtocol {
    
    func fetchRates(with parameters: LatestRatesParameters, date: Date, _ completion: @escaping (Result<LatestRatesResponse, Error>) -> Void) {
        let request = RequestGenerator<LatestRatesResponse>(type: .get, encodingType: .query, endPoint: DateEndPoint(date: date), parameters: parameters)
        fetch(request: request, completion: completion)
    }
    
}
