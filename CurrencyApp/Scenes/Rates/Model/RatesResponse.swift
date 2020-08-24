//
//  RatesResponse.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

struct RatesResponse: Decodable {
    let USD: Double
    let EUR: Double?
    let RUB: Double
}
