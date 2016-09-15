//
//  HOTPGenerator.swift
//  OTPKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation
import CryptoKit

/// An HMAC-based one-time password (HOTP) generator based on RFC 4226.
/// It contains the parameters needed for generating a one-time password.
public struct HOTPGenerator {
    /// The hash function to be used for generating an HMAC. Default hash function is `.sha1`.
    public var hashFunction: HashFunction
    
    /// The shared unique secret key.
    public var key: Data
    
    /// The number of digits of the password. Valid values are in the range `6...8`. Default value is `6`.
    public var digits: UInt
    
    /// Creates an HMAC-based one-time password generator based on the given parameters.
    /// - parameters:
    ///   - key: The shared unique secret key.
    ///   - digits: The number of digits of the password. Valid values are in the range `6...8`. Default value is `6`.
    ///   - hashFunction: The hash function to be used for generating an HMAC. Default hash function is `.sha1`.
    public init(key: Data, digits: UInt = 6, hashFunction: HashFunction = .sha1) {
        self.key = key
        self.digits = digits
        self.hashFunction = hashFunction
    }
    
    /// Returns a password based on the counter value and the parameters of the `HOTPGenerator` instance.
    /// - parameters:
    ///   - counter: An 8-byte counter value, the moving factor.
    /// - throws: Throws an `HOTPError` case if unable to generate a password.
    /// - returns: A one-time password based on the parameters.
    public func password(counter: UInt64) throws -> String {
        return try HOTP.generate(key: key, counter: counter, digits: digits, hashFunction: hashFunction)
    }
}
