//
//  CounterBasedOTP+HMAC.swift
//  OTPKit
//
//  Created by Chris Amanse on 03/09/2016.
//
//

import Foundation
import CryptoKit

public extension CounterBasedOTP where Self: HMAC {
    public static func generatePassword(key: Data, counter: UInt64, digits: Int) -> String {
        // Get big-endian data representation of counter
        let counterData = Data(from: counter.bigEndian)
        
        // HMAC message with key
        let hmacResult = self.hmac(key: key, message: counterData)
        
        // Get offset
        let offset = Int((hmacResult.last ?? 0x00) & 0x0f)
        
        // Truncate hmac result into 32-bit integer (big-endian)
        let truncated = hmacResult.withUnsafeBytes { (bytePointer: UnsafePointer<UInt8>) -> UInt32 in
            let offsetPointer = bytePointer.advanced(by: offset)
            
            return offsetPointer.withMemoryRebound(to: UInt32.self, capacity: MemoryLayout<UInt32>.size) { $0.pointee.bigEndian }
        }
        
        // Discard the most significant bit
        let discardedMSB = truncated & 0x7FFFFFFF
        
        // Limit the number of digits
        let modulus = UInt32(pow(10, Float(digits)))
        
        let stringValue = String(discardedMSB % modulus)
        
        // Create left padding if current digits count is not enough
        let paddingCount = digits - stringValue.characters.count
        if paddingCount != 0 {
            return String(repeating: "0", count: paddingCount) + stringValue
        } else {
            return stringValue
        }
    }
}
