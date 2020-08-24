//
//  RequestError.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

struct RequestErrorResponse: Decodable {
    let error: RequestError?
    
    enum CodingKeys: String, CodingKey {
        case error = "Error"
    }
}

struct RequestError: Decodable, LocalizedError {
    let code: Int?
    let message: String?
    let developerMessage: String?
    
    var errorDescription: String? {
        return nil//errorString()
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case developerMessage
    }
    
//    func errorTitle() -> String {
//        let error = StoreWardsError.init(rawValue: code ?? 0)
//        return error?.title ?? "ERROR"
//    }
//
//    func errorString() -> String {
//        if let error = StoreWardsError.init(rawValue: code ?? 0), error != .unknowError {
//            return error.errorDescription
//        }
//
//        return message ?? StoreWardsError.unknowError.errorDescription
//    }
//
//    static let accountBlockedNotification: Notification.Name = Notification.Name(rawValue: "AccountBlocked")
}
