//
//  CounterBasedOTP.swift
//  OTPKit
//
//  Created by Chris Amanse on 03/09/2016.
//
//

import Foundation

public protocol CounterBasedOTP {
    static func generatePassword(key: Data, counter: UInt64, digits: Int) -> String
}
