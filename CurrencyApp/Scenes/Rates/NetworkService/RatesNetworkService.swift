//
//  CurrencyNetworkService.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

enum Currency: String {
    case USD
    case EUR
    case RUB
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
    
    func convertToDictionary() -> [String : Any] {
        return ["base": base.rawValue]
    }
}

class RatesNetworkService: APIClientProtocol {
    
    func fetchLatestRates(with parameters: LatestRatesParameters, _ completion: @escaping (Result<LatestRatesResponse, Error>) -> Void) {
        let request = RequestGenerator<LatestRatesResponse>(type: .get, encodingType: .query, endPoint: EndPoint.latest, parameters: parameters)
        fetch(request: request, completion: completion)
    }
    
}
