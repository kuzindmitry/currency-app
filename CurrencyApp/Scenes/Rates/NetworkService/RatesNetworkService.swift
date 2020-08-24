//
//  CurrencyNetworkService.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

class RatesNetworkService: APIClientProtocol {
    
    func fetchRates(with parameters: DateRatesParameters, date: Date, _ completion: @escaping (Result<DateRatesResponse, Error>) -> Void) {
        let request = RequestGenerator<DateRatesResponse>(type: .get, encodingType: .query, endPoint: DateEndPoint(date: date), parameters: parameters)
        fetch(request: request, completion: completion)
    }
    
}
