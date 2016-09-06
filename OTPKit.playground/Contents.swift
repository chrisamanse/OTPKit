//: Playground - noun: a place where people can play

import Foundation
import OTPKit

var str = "Hello, playground"

let base32String = "V3ZMBGAETLLSXRJZ6QZD42Z33O3DK3R7"

guard let secret = try? Base32.decode(base32String) else {
    abort()
}

let passwordGenerator = TOTPGenerator(key: secret, period: 30, digits: 6, hashFunction: .sha1)

try? passwordGenerator.password(date: Date())
try? passwordGenerator.password(date: Date() + 30)
