//
//  Base32.swift
//  OTPKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation

public enum Base32 {
    // Encoding
    
    public static func encode(_ data: Data) -> String {
        var characters: [Character] = []
        
        // Divide into groups of 5 bytes
        let pieceLength = 5
        for index in stride(from: data.startIndex, to: data.endIndex, by: pieceLength) {
            // Get subdata piece
            let stride = index + pieceLength
            let upperLimitIndex = stride < data.endIndex ? stride : data.endIndex
            
            let piece = data.subdata(in: index ..< upperLimitIndex)
            
            // Combine 5 bytes into a single Int
            var integer: UInt64 = 0
            
            for (index, byte) in piece.enumerated() {
                let shiftLeftsCount = (4 - index) * 8
                let shifted = Int(byte) << shiftLeftsCount
                
                integer = integer | UInt64(shifted)
            }
            
            // Divide 40 bits into 5 bits (8 groups)
            for index2 in 0..<8 {
                // Check if bytes left is less than 5 bytes
                let bytesLeft = index.distance(to: data.endIndex)
                
                // Pad if less than 5 bytes
                if bytesLeft < 5 {
                    // Compute padding count
                    let paddingCount: Int = {
                        switch bytesLeft {
                        case 1: return 6
                        case 2: return 4
                        case 3: return 3
                        case 4: return 1
                        default: return 0
                        }
                    }()
                    
                    // Only pad when all nickels are mapped
                    if paddingCount > 7 - index2 {
                        for _ in 0 ..< paddingCount {
                            characters.append(Character("="))
                        }
                        
                        // No need to map nickels
                        break
                    }
                }
                
                // Shift target bits to the right most for masking
                let shiftRightCount = (7 - index2) * 5
                
                let nickel = (integer >> UInt64(shiftRightCount)) & 0x1f
                
                // Evaluate mapped character
                if let character = character(for: UInt8(nickel)) {
                    characters.append(character)
                }
            }
        }
        
        return String(characters)
    }
    
    
    // Decoding
    
    public static func decode(_ string: String) throws -> Data {
        guard !string.isEmpty else {
            return Data()
        }
        
        var bytes: [UInt8] = []
        
        // Divide into groups of 8 characters
        var lowerBoundIndex = string.startIndex
        var upperBoundIndex = string.startIndex
        
        repeat {
            lowerBoundIndex = upperBoundIndex
            upperBoundIndex = string.index(upperBoundIndex, offsetBy: 8, limitedBy: string.endIndex) ?? string.endIndex
            
            let substring = string.substring(with: lowerBoundIndex ..< upperBoundIndex)
            
            // Decode characters into nickels and combine into a five byte Int
            let decodedBytes = substring.characters.lazy.map { value(for: $0) }
            
            var fiveByte: UInt64 = 0
            
            for (index, someByte) in decodedBytes.enumerated() {
                guard let byte = someByte else {
                    // Get invalid character
                    let stringIndex = substring.index(substring.startIndex, offsetBy: index)
                    
                    // Throw invalid character
                    throw Base32DecodingError.invalidCharacter(character: substring[stringIndex])
                }
                
                let shiftLeftsCount: UInt64 = (7 - UInt64(index)) * 5
                
                let shiftedNickel = UInt64(byte) << shiftLeftsCount
                
                fiveByte = fiveByte | shiftedNickel
            }
            
            // Split five byte Int into UInt8's
            for index in 0..<5 {
                let shiftRightsCount: UInt64 = (4 - UInt64(index)) * 8
                
                let shifted = fiveByte >> shiftRightsCount
                
                let byte = UInt8(shifted & 0x00000000ff)
                
                bytes.append(byte)
            }
        } while upperBoundIndex < string.endIndex
        
        // Remove trailing zeroes for "=" padding
        
        var trailingCount = 0
        
        var index: String.CharacterView.Index? = string.index(string.startIndex, offsetBy: string.characters.count - 1)
        while let i = index, string[i] == "=" && trailingCount < 6 {
            trailingCount += 1
            
            index = string.index(i, offsetBy: -1, limitedBy: string.startIndex)
        }
        
        let paddedBytesCount: Int = {
            switch trailingCount {
            case 1: return 1
            case 3: return 2
            case 4: return 3
            case 6: return 4
            default: return 0
            }
        }()
        
        bytes.removeLast(paddedBytesCount)
        
        return Data(bytes)
    }
    
    // Base 32 alphabet
    
    /// Get corresponding character for a value.
    /// - parameters:
    ///   - value: A value in the range `0..<32`.
    /// - returns: The mapped character to the `value`.
    ///   Returns `nil` if invalid value.
    public static func character(for value: UInt8) -> Character? {
        let unicodeScalarValue: UInt32?
        
        switch value {
        case 0...25:
            unicodeScalarValue = "A".unicodeScalars.first!.value + UInt32(value)
        case 26...31:
            unicodeScalarValue = "2".unicodeScalars.first!.value + UInt32(value) - 26
        default:
            unicodeScalarValue = nil
        }
        
        if let value = unicodeScalarValue, let unicode = UnicodeScalar(value) {
            return Character(unicode)
        } else {
            return nil
        }
    }
    
    /// Get corresponding value for a character.
    /// - parameters:
    ///   - character: A character in the Base 32 alphabet
    /// - returns: The value for the mapped character.
    ///   Returns `nil` if invalid character.
    public static func value(for character: Character) -> UInt8? {
        let unicodeScalarValue = String(character).unicodeScalars.first!.value
        
        switch unicodeScalarValue {
        case 50...55:
            // "2"..."7"
            return UInt8(unicodeScalarValue - 24)
        case 61:
            // "="
            return 0x00
        case 65...90:
            // "A"..."Z"
            return UInt8(unicodeScalarValue - 65)
        default:
            return nil
        }
    }
}

public enum Base32DecodingError: Error {
    /// The Base 32 string contains an invalid character.
    /// Valid characters are `"A"..."Z"`, `"2"..."7"`, and `"="`.
    case invalidCharacter(character: Character)
}
