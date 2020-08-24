//
//  APIParametersProtocol.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

protocol APIParametersProtocol {
    func convertToDictionary() -> [String: Any]
}

extension APIParametersProtocol {
    static func empty() -> [String: Any] {
        return [:]
    }
}
