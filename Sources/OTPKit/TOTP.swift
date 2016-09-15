//
//  TOTP.swift
//  OTPKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation
import CryptoKit

/// Contains the implementation for generating a TOTP.
public enum TOTP {
    /// Returns a password based on the given parameters.
    /// - parameters:
    ///   - key: The shared unique secret key.
    ///   - timeInterval: The number of seconds elapsed since the Unix epoch time (January 1, 1970 00:00 UTC).
    ///   - period: The time step in seconds. Default value is `30.0`.
    ///   - digits: The number of digits of the password. Valid values are in the range `6...8`. Default value is `6`.
    ///   - hashFunction: The hash function to be used for generating an HMAC. Default hash function is `.sha1`.
    /// - throws: Throws an `HOTPError` or `TOTPError` case if unable to generate a password.
    /// - returns: A one-time password based on the parameters.
    public static func generate(key: Data, timeInterval: TimeInterval, period: TimeInterval = 30, digits: UInt = 6, hashFunction: HashFunction = .sha1) throws -> String {
        try TOTPValidator.validate(period: period)
        try TOTPValidator.validate(timeInterval: timeInterval)
        
        /// Get counter value to be used for HOTP generation
        let counter = UInt64(timeInterval / period)
        
        return try HOTP.generate(key: key, counter: counter, digits: digits, hashFunction: hashFunction)
    }
}

/// Error type thrown when a time-based one-time password can not be generated.
enum TOTPError: Error {
    /// The period should be greater than 0.
    case InvalidPeriod
    
    /// The time interval should be greater than 0.
    case InvalidTimeInterval
}

/// Contains functions for validating parameters for generating a TOTP.
enum TOTPValidator {
    /// Validate the time interval.
    static func validate(timeInterval: TimeInterval) throws {
        if timeInterval < 0 {
            throw TOTPError.InvalidTimeInterval
        }
    }
    
    /// Validate the period.
    static func validate(period: TimeInterval) throws {
        if period < 0 {
            throw TOTPError.InvalidPeriod
        }
    }
}
