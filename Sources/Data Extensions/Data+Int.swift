//
//  Data+Int.swift
//  OTPKit
//
//  Created by Chris Amanse on 03/09/2016.
//
//

import Foundation

extension Data {
    init<T: Integer>(from value: T) {
        let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        defer {
            valuePointer.deallocate(capacity: 1)
        }
        
        valuePointer.pointee = value
        
        let bytesPointer = valuePointer.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<UInt8>.size) { $0 }
        
        self.init(bytes: bytesPointer, count: MemoryLayout<T>.size)
    }
}
