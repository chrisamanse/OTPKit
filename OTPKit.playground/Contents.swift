//: Playground - noun: a place where people can play

import Foundation
import OTPKit

var str = "Hello, playground"

let base32String = "V3ZMBGAETLLSXRJZ6QZD42Z33O3DK3R7"

let secret = try! Base32.decode(base32String)

let passwordGenerator = TOTPGenerator(key: secret, period: 30, digits: 6, hashFunction: .sha1)

let now = Date()
try? passwordGenerator.password(for: now)
try? passwordGenerator.password(for: now + 30)
