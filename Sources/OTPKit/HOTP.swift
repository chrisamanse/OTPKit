//
//  HOTP.swift
//  OTPKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation
import CryptoKit

/// Contains the implementation for generating a HOTP.
public enum HOTP {
    /// Returns a password based on the given parameters.
    /// - parameters:
    ///   - key: The shared unique secret key.
    ///   - counter: An 8-byte counter value, the moving factor.
    ///   - digits: The number of digits of the password. Valid values are in the range `6...8`. Default value is `6`.
    ///   - hashFunction: The hash function to be used for generating an HMAC. Default hash function is `.sha1`.
    /// - throws: Throws an `HOTPError` case if unable to generate a password.
    /// - returns: A one-time password based on the parameters.
    public static func generate(key: Data, counter: UInt64, digits: UInt = 6, hashFunction: HashFunction = .sha1) throws -> String {
        try HOTPValidator.validate(digits: digits)
        
        // Get data representation of counter in big-endian
        let message = Data(from: counter.bigEndian)
        
        // Get HMAC value
        let hmac = HMAC(key: key, message: message, hashFunction: hashFunction)
        
        // Get offset
        let offset = Int((hmac.last ?? 0x00) & 0x0f)
        
        // Truncate HMAC into 32-bit integer (big-endian)
        let truncated = hmac.withUnsafeBytes { (bytePointer: UnsafePointer<UInt8>) -> UInt32 in
            let offsetPointer = bytePointer.advanced(by: offset)
            
            return offsetPointer.withMemoryRebound(to: UInt32.self, capacity: MemoryLayout<UInt32>.size) { $0.pointee.bigEndian }
        }
        
        // Discard most significant bit
        let discardedMSB = truncated & 0x7fffffff
        
        // Limit the number of digits
        let modulus = UInt32(pow(10, Float(digits)))
        
        let stringValue = String(discardedMSB % modulus)
        
        // Create left padding if current digits count is not enough
        let paddingCount = Int(digits) - stringValue.characters.count
        if paddingCount != 0 {
            return String(repeating: "0", count: paddingCount) + stringValue
        } else {
            return stringValue
        }
    }
}

/// Error type thrown when an HMAC-based one-time password can not be generated.
public enum HOTPError: Error {
    /// The number of digits is not within the range `6...8`.
    case InvalidDigits
}

/// Contains functions for validating parameters for generating a HOTP.
enum HOTPValidator {
    /// Validate the number of digits.
    static func validate(digits: UInt) throws {
        if !(6...8).contains(digits) {
            throw HOTPError.InvalidDigits
        }
    }
}

