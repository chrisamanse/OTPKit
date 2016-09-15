//
//  TOTPGenerator.swift
//  OTPKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation
import CryptoKit

/// An time-based one-time password (TOTP) generator based on RFC 6238.
/// It contains the parameters needed for generating a one-time password.
public struct TOTPGenerator {
    /// The hash function to be used for generating an HMAC. Default hash function is `.sha1`.
    public var hashFunction: HashFunction
    
    /// The shared unique secret key.
    public var key: Data
    
    /// The number of digits of the password. Valid values are in the range `6...8`. Default value is `6`.
    public var digits: UInt
    
    /// The time step in seconds. Default value is `30.0`.
    public var period: TimeInterval
    
    /// Creates an HMAC-based one-time password generator based on the given parameters.
    /// - parameters:
    ///   - key: The shared unique secret key.
    ///   - period: The time step in seconds. Default value is `30.0`.
    ///   - digits: The number of digits of the password. Valid values are in the range `6...8`. Default value is `6`.
    ///   - hashFunction: The hash function to be used for generating an HMAC. Default hash function is `.sha1`.
    public init(key: Data, period: TimeInterval = 30, digits: UInt = 6, hashFunction: HashFunction = .sha1) {
        self.key = key
        self.period = period
        self.digits = digits
        self.hashFunction = hashFunction
    }
    
    /// Returns a password based on the counter value and the parameters of the `HOTPGenerator` instance.
    /// - parameters:
    ///   - timeInterval: The number of seconds elapsed since the Unix epoch time (January 1, 1970 00:00 UTC).
    /// - throws: Throws an `HOTPError` or `TOTPError` case if unable to generate a password.
    /// - returns: A one-time password based on the time interval.
    public func password(forTimeInterval timeInterval: TimeInterval) throws -> String {
        return try TOTP.generate(key: key, timeInterval: timeInterval, period: period, digits: digits, hashFunction: hashFunction)
    }
    
    /// Returns a password based on the counter value and the parameters of the `HOTPGenerator` instance.
    /// - parameters:
    ///   - date: The date for where the time interval will be derived.
    ///     The time interval is the number of seconds elapsed until `date` since the Unix epoch time
    ///     (January 1, 1970 00:00 UTC).
    /// - throws: Throws an `HOTPError` or `TOTPError` case if unable to generate a password.
    /// - returns: A one-time password based on the date.
    public func password(for date: Date) throws -> String {
        return try password(forTimeInterval: date.timeIntervalSince1970)
    }
}
