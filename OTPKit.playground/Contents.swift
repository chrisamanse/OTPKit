//: Playground - noun: a place where people can play

import Foundation
import OTPKit

var str = "Hello, playground"

let base32String = "V3ZMBGAETLLSXRJZ6QZD42Z33O3DK3R7"

let secret = try! Base32.decode(base32String)

let passwordGenerator = HOTPGenerator(key: secret, digits: 6, hashFunction: .sha1)

var passwords: [String] = []

for i in 1...100 {
    guard let password = try? passwordGenerator.password(counter: UInt64(i)) else {
        break
    }
    
    passwords.append(password)
}

print(passwords)